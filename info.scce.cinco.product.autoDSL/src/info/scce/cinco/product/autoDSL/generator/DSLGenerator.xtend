package info.scce.cinco.product.autoDSL.generator

import de.jabc.cinco.meta.core.utils.EclipseFileUtils
import de.jabc.cinco.meta.core.utils.projects.ProjectCreator
import de.jabc.cinco.meta.plugin.generator.runtime.IGenerator
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import java.util.ArrayList
import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL
import info.scce.cinco.product.autoDSL.autodsl.autodsl.OffState
import info.scce.cinco.product.autoDSL.autodsl.autodsl.State
import info.scce.cinco.product.autoDSL.autodsl.autodsl.Guard
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import java.util.function.Predicate

class DSLGenerator implements IGenerator<AutoDSL> {
	var IFolder mainFolder
	var IFolder mainPackage
	
	override generate(AutoDSL dsl, IPath targetDir, IProgressMonitor monitor) {
		val ArrayList<String> srcFolders = new ArrayList<String>();
		srcFolders.add("src-gen")
		
		val IProject project = ProjectCreator.createProject("Generated Product",srcFolders,null,null,null,null,monitor)
		mainFolder = project.getFolder("src-gen")
		mainPackage = mainFolder.getFolder("info/scce/cinco/product")
		EclipseFileUtils.mkdirs(mainPackage,monitor)
		
		generateStatic()
		
		EclipseFileUtils.writeToFile(mainPackage.getFile("AutoDSL" + IDHasher.GetStringHash(dsl.id) + ".java"), generateStateMachine(dsl))
	}
	
	def generateStatic(){
		EclipseFileUtils.writeToFile(mainPackage.getFile("State.java"), StateClass())
		EclipseFileUtils.writeToFile(mainPackage.getFile("MultiState.java"),MultiStateClass())
		EclipseFileUtils.writeToFile(mainPackage.getFile("StateMachine.java"),StateMachineClass())
	}
	
	def generateStateMachine(AutoDSL dsl)'''
	package info.scce.cinco.product;
	
	import java.util.HashMap;
	
	public class AutoDSL«IDHasher.GetStringHash(dsl.id)» extends StateMachine{
		HashMap<Integer, MultiState> states;
		
		public AutoDSL«IDHasher.GetStringHash(dsl.id)»(){
			states = new HashMap<>();
			
			«if(dsl.offStates.length() > 0) generateAllStates(dsl)»
			
			«if(dsl.offStates.length() > 0) generateAllOffStates(dsl)»
			
			«if(dsl.offStates.length() > 0) generateAllGuards(dsl)»
			
			«if(dsl.offStates.length() > 0) chooseEntryState(dsl)»
			}
		}
	'''
	
	def generateAllStates(AutoDSL dsl)'''
	//Add all states	
	«FOR state : dsl.states SEPARATOR '\n'»
	«generateState(state, IDHasher.GetIntHash(state.id))»
	«ENDFOR»
	'''
	
	def generateAllOffStates(AutoDSL dsl)'''
	//Add all offstates
	«FOR state : dsl.offStates SEPARATOR '\n'»
	«generateOffState(state, IDHasher.GetIntHash(state.id))»
	«ENDFOR»
	'''
	
	def generateAllGuards(AutoDSL dsl)'''
	//Connect all states
	«FOR guard : dsl.guards SEPARATOR ''»
	«connectStates(guard)»
	«ENDFOR»
	'''
	
	def chooseEntryState(AutoDSL dsl)'''
	//Select entry state
	SetEntryState(states.get(«IDHasher.GetIntHash(dsl.offStates.get(0).id)»));
	'''
	
	def generateState(State state, int index)'''
	MultiState state«index» = new MultiState();
	«FOR container : state.componentNodes SEPARATOR '\n'»
	«if(container.rule != null) container.rule.name = "Rule" + IDHasher.GetStringHash(container.rule.id)»
	state«index».AddState(new Rule«IDHasher.GetStringHash(container.rule.id)»());
	«if(container.rule != null) EclipseFileUtils.writeToFile(mainPackage.getFile("Rule" + IDHasher.GetStringHash(container.rule.id) + ".java"),new NodeGenerator().generate(container.rule))»
	«ENDFOR»
	states.put(«IDHasher.GetIntHash(state.id)», state«index»);
	'''
	
	static def generateOffState(OffState state, int index)'''
	MultiState state«index» = new MultiState();
	states.put(«IDHasher.GetIntHash(state.id)», state«index»);
	'''
	
	def connectStates(Guard guard){
	var incomingEdges = getIncomingEdges(guard)
	var outgoingEdges = getOutgoingEdges(guard)
	
	for(container : guard.componentNodes)
		if(container.rule != null){
		 container.rule.name = "Rule" + IDHasher.GetStringHash(container.rule.id);
		 EclipseFileUtils.writeToFile(mainPackage.getFile("Rule" + IDHasher.GetStringHash(container.rule.id) + ".java"),
		 								new NodeGenerator().generate(container.rule))
	}
		 								
	
	'''	
	«FOR inEdge : incomingEdges SEPARATOR '\n'»
	«FOR outEdge : outgoingEdges SEPARATOR '\n'»
	AddTransition(states.get(«IDHasher.GetIntHash(inEdge.sourceElement.id)»), states.get(«IDHasher.GetIntHash(outEdge.targetElement.id)»), (State state) -> true);
	«ENDFOR»
	«ENDFOR»
	'''
	}
	
	def getIncomingEdges(Guard guard){
		return guard.incoming.filter[it.sourceElement instanceof State] + guard.incoming.filter[it.sourceElement instanceof OffState];
	}
	
	def getOutgoingEdges(Guard guard){
		return guard.outgoing.filter[it.targetElement instanceof State] + guard.outgoing.filter[it.targetElement instanceof OffState];
	}
	
	static def StateMachineClass() '''	
	package info.scce.cinco.product;
	
	import java.util.HashMap;
	import java.util.List;
	import java.util.ArrayList;
	import java.util.function.Predicate;
	
	public class StateMachine {
		//Describes the (conditional) transition from one known state to another 
		private class Transition{
			State targetState;
			Predicate<State> condition;
			
			public Transition(State targetState, Predicate<State> condition){
				assert(targetState != null);
				
				this.targetState = targetState;
				this.condition = condition;
			}
			
			@Override
			public boolean equals(Object obj){
				if(obj == null)
					return false;
				
				if(obj.getClass() != this.getClass())
					return false;
				
				Transition tmp = (Transition)obj;
				return targetState.equals(tmp.targetState) && condition.equals(tmp.condition);
			}
		}
		
		//Member variables
		private State currentState;
		//Contains a state and all the transitions leading away from this state
		private HashMap<State, List<Transition>> transitions; 
		
		private State entryState;
		
		//Constructor
		public StateMachine(){
			currentState = null;
			transitions = new HashMap<>();
			entryState = null;
		}
		
		//Executes the current state and tries to perform the transition to the next state
		public void Run(){
			assert(currentState != null);
			
			currentState.Execute();
			
			//Check for the first transition where the condition is fulfilled and follow that transition
			List<Transition> stateTransitions = transitions.get(currentState);
			for (Transition transition : stateTransitions) {
				if(transition.condition.test(currentState)){
					currentState.onExit();
					currentState = transition.targetState;
					currentState.onEntry();
					break;
				}
			}
		}
		
		public void AddTransition(State from, State to, Predicate<State> condition){
			List<Transition> stateTransitions = transitions.get(from);
			Transition newTransition = new Transition(to, condition);
			
			if(stateTransitions == null){
				stateTransitions = new ArrayList<>();
				stateTransitions.add(newTransition);
			}else if(!stateTransitions.contains(newTransition)){
				stateTransitions.add(newTransition);
			}
			
			transitions.put(from, stateTransitions);
		}
		
		public void SetEntryState(State entryState){
			this.entryState = entryState;
			
			if(currentState == null)
				this.currentState = this.entryState;
		}
		
		public boolean isInEntryState(){ return this.entryState.equals(this.currentState); }
		public State getCurrentState(){ return currentState; }
	}
	'''
	
	static def StateClass() '''
	package info.scce.cinco.product;
	
	interface State {
		public abstract void onEntry();
		public abstract void Execute();
		public abstract void onExit();
		public abstract String getName();
	}
	'''
	
	static def MultiStateClass() '''
	package info.scce.cinco.product;
	
	import java.util.ArrayList;
	import java.util.List;
	
	public class MultiState implements State{
		private List<State> states = new ArrayList<>();
		
		public void onEntry(){
			for(State state : states)
				state.onEntry();
		}
		
		public void Execute(){
			for(State state : states)
				state.Execute();
		}
		
		public void onExit(){
			for(State state : states)
				state.onExit();
		}
		
		public String getName(){
			String rules = "MultiState";
			for(State state : states)
				rules += " " + state.getName();
			return rules;
		}
		
		public void AddState(State state){
			if(!states.contains(state))
				states.add(state);
		}
	}
	'''
}