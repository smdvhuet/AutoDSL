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
import java.util.HashMap

class DSLGenerator implements IGenerator<AutoDSL> {
	var IFolder mainFolder
	var IFolder mainPackage
	var HashMap<Integer, String> knownRuleTypes =  new HashMap<Integer, String>()
	
	override generate(AutoDSL dsl, IPath targetDir, IProgressMonitor monitor) {
		knownRuleTypes.clear();
		
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
		EclipseFileUtils.writeToFile(mainPackage.getFile("State.java"), StaticClasses::StateClass())
		EclipseFileUtils.writeToFile(mainPackage.getFile("MultiState.java"), StaticClasses::MultiStateClass())
		EclipseFileUtils.writeToFile(mainPackage.getFile("StateMachine.java"), StaticClasses::StateMachineClass())
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
	«IF container.rule != null»
	state«index».AddState(«generateNewRule(container.rule)»);
	«ENDIF»
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
		 generateNewRule(container.rule)
	}
		 								
	
	'''	
	«FOR inEdge : incomingEdges SEPARATOR '\n'»
	«FOR outEdge : outgoingEdges SEPARATOR '\n'»
	
	«FOR container : guard.componentNodes SEPARATOR '\n'»
	//Predicate<State> guard_«IDHasher.GetStringHash(guard.id)» = () -> true «if(container.rule != null) generateNewRule(container.rule)»
	«ENDFOR»
	AddTransition(states.get(«IDHasher.GetIntHash(inEdge.sourceElement.id)»), states.get(«IDHasher.GetIntHash(outEdge.targetElement.id)»), (State state) -> true);
	«ENDFOR»
	«ENDFOR»
	'''
	}
	
	def generateNewRule(Rule rule){
	  var String ruleName = knownRuleTypes.get(IDHasher.GetIntHash(rule.id))
	  if(ruleName == null){
	  	rule.name = "Rule" + IDHasher.GetStringHash(rule.id)
	  	EclipseFileUtils.writeToFile(mainPackage.getFile(rule.name + ".java"), new NodeGenerator().generate(rule))
	  	knownRuleTypes.put(IDHasher.GetIntHash(rule.id), rule.name)
	  	ruleName = rule.name	
	  }
	  
	  return '''new «ruleName»() '''
	}
	
	def getIncomingEdges(Guard guard){
		return guard.incoming.filter[it.sourceElement instanceof State] + guard.incoming.filter[it.sourceElement instanceof OffState];
	}
	
	def getOutgoingEdges(Guard guard){
		return guard.outgoing.filter[it.targetElement instanceof State] + guard.outgoing.filter[it.targetElement instanceof OffState];
	}
}