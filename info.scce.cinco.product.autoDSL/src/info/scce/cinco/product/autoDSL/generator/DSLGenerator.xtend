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
import java.util.HashMap

class DSLGenerator implements IGenerator<AutoDSL> {
	var IFolder mainFolder
	var IFolder mainPackage
	var IFolder corePackage
	var IFolder guiPackage
	var HashMap<Integer, String> knownRuleTypes =  new HashMap<Integer, String>()
	var HashMap<Integer, String> knownGuardFunctions = new HashMap<Integer, String>()
	
	override generate(AutoDSL dsl, IPath targetDir, IProgressMonitor monitor) {
		knownRuleTypes.clear();
		
		val ArrayList<String> srcFolders = new ArrayList<String>();
		srcFolders.add("src-gen")
		
		val IProject project = ProjectCreator.createProject("Generated Product",srcFolders,null,null,null,null,monitor)
		mainFolder = project.getFolder("src-gen")
		mainPackage = mainFolder.getFolder("info/scce/cinco/product")
		EclipseFileUtils.mkdirs(mainPackage,monitor)
		corePackage = mainFolder.getFolder("info/scce/cinco/core")
		EclipseFileUtils.mkdirs(corePackage,monitor)
		guiPackage = mainFolder.getFolder("info/scce/cinco/gui")
		EclipseFileUtils.mkdirs(guiPackage,monitor)
		
		generateStatic(dsl)
		
		EclipseFileUtils.writeToFile(mainPackage.getFile("AutoDSL" + IDHasher.GetStringHash(dsl.id) + ".java"), generateStateMachine(dsl))
	}
	
	def generateStatic(AutoDSL dsl){
		EclipseFileUtils.writeToFile(corePackage.getFile("State.java"), StaticClasses::StateClass())
		EclipseFileUtils.writeToFile(corePackage.getFile("MultiState.java"), StaticClasses::MultiStateClass())
		EclipseFileUtils.writeToFile(corePackage.getFile("StateMachine.java"), StaticClasses::StateMachineClass())
		EclipseFileUtils.writeToFile(corePackage.getFile("Utility.java"), StaticClasses::UtilityClass())
		EclipseFileUtils.writeToFile(corePackage.getFile("PID.java"), StaticClasses::PIDClass())
		EclipseFileUtils.writeToFile(mainPackage.getFile("EgoCar.java"), new EgoCarGenerator().generateEgoCar(dsl))

		
		EclipseFileUtils.writeToFile(guiPackage.getFile("SimulatorPanel.java"), GuiGenerator::generateSimulatorPanel())
		EclipseFileUtils.writeToFile(guiPackage.getFile("SimControlPanel.java"), GuiGenerator::generateSimControlPanel())
		EclipseFileUtils.writeToFile(guiPackage.getFile("RoadVisualizationPanel.java"), GuiGenerator::generateRoadVisualizationPanel())
		EclipseFileUtils.writeToFile(guiPackage.getFile("Mode.java"), GuiGenerator::generateMode())
		EclipseFileUtils.writeToFile(guiPackage.getFile("generateInfoPanel.java"), GuiGenerator::generateInfoPanel())
		EclipseFileUtils.writeToFile(guiPackage.getFile("CarControlsPanel.java"), GuiGenerator::generateCarControlsPanel())
		EclipseFileUtils.writeToFile(guiPackage.getFile("InteractiveSimulator.java"), GuiGenerator::generateInteractiveSimulator())
	}
	
	def generateStateMachine(AutoDSL dsl)'''
	package info.scce.cinco.product;
	
	import java.util.function.Predicate;
	import java.util.HashMap;
	import info.scce.cinco.core.MultiState;
	import info.scce.cinco.core.State;
	import info.scce.cinco.core.StateMachine;
	
	public class AutoDSL«IDHasher.GetStringHash(dsl.id)» extends StateMachine{
		HashMap<Integer, MultiState> states = new HashMap<>();
		«registerAllGuardValidationFunctions(dsl)»
		
		public AutoDSL«IDHasher.GetStringHash(dsl.id)»(){
			«if(dsl.offStates.length() > 0) generateAllStates(dsl)»
			
			«if(dsl.offStates.length() > 0) generateAllOffStates(dsl)»
			
			«if(dsl.offStates.length() > 0) generateAllGuards(dsl)»
			
			«if(dsl.offStates.length() > 0) chooseEntryState(dsl)»
		}
		
		«generateAllGuardValidtionsFunctions(dsl)»
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
	state«index».AddState(new «generateRuleType(container.rule)»());
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
		  generateRuleType(container.rule)
	}
		 								
	
	'''	
	«FOR inEdge : incomingEdges SEPARATOR '\n'»
	«FOR outEdge : outgoingEdges SEPARATOR '\n'»
	Predicate<State> guard«IDHasher.GetStringHash(guard.id)» = (State state) -> «FOR container : guard.componentNodes SEPARATOR '&&'»«IF container.rule != null»«knownGuardFunctions.get(IDHasher.GetIntHash(container.rule.id))»()«ELSE»true«ENDIF»  «ENDFOR»;
	AddTransition(states.get(«IDHasher.GetIntHash(inEdge.sourceElement.id)»), states.get(«IDHasher.GetIntHash(outEdge.targetElement.id)»), guard«IDHasher.GetStringHash(guard.id)»);
	«ENDFOR»
	«ENDFOR»
	'''
	}
	
	def generateRuleType(Rule rule){
	  var String ruleName = knownRuleTypes.get(IDHasher.GetIntHash(rule.id))
	  if(ruleName == null){
	  	rule.name = "Rule" + IDHasher.GetStringHash(rule.id)
	  	EclipseFileUtils.writeToFile(mainPackage.getFile(rule.name + ".java"), new NodeGenerator().generate(rule))
	  	knownRuleTypes.put(IDHasher.GetIntHash(rule.id), rule.name)
	  	ruleName = rule.name	
	  }
	  
	  return '''«ruleName»'''
	}
	
	def registerAllGuardValidationFunctions(AutoDSL dsl){
		for(guard : dsl.guards)
			for(container : guard.componentNodes)
				if(container != null && container.rule != null)
					generateGuardValidationFunction(container.rule)
		return ''
	}
	
	def generateAllGuardValidtionsFunctions(AutoDSL dsl){
		knownGuardFunctions.clear();
		'''
		«FOR guard : dsl.guards SEPARATOR '\n'»
		«FOR container : guard.componentNodes SEPARATOR ' '»
		«IF container != null && container.rule != null»
		«generateGuardValidationFunction(container.rule)»
		«ENDIF»
		«ENDFOR»
		«ENDFOR»
		'''
	}
	
	def generateGuardValidationFunction(Rule guardingRule){
		if(knownGuardFunctions.containsKey(IDHasher.GetIntHash(guardingRule.id))){
			return ''
		}else{
			val guardName = "isGuardValid" + IDHasher.GetStringHash(guardingRule.id)
			knownGuardFunctions.put(IDHasher.GetIntHash(guardingRule.id), guardName)
			return '''
			«generateRuleType(guardingRule)» guardRule«IDHasher.GetStringHash(guardingRule.id)» = new «generateRuleType(guardingRule)»(); 
			private boolean «guardName»(){
				boolean result = false;
				
				guardRule«IDHasher.GetStringHash(guardingRule.id)».onEntry();
				guardRule«IDHasher.GetStringHash(guardingRule.id)».Execute();
				result = guardRule«IDHasher.GetStringHash(guardingRule.id)».guard;
				guardRule«IDHasher.GetStringHash(guardingRule.id)».onExit();
				
				return result;
			}
			'''
		}
	}
	
	def getIncomingEdges(Guard guard){
		return guard.incoming.filter[it.sourceElement instanceof State] + guard.incoming.filter[it.sourceElement instanceof OffState];
	}
	
	def getOutgoingEdges(Guard guard){
		return guard.outgoing.filter[it.targetElement instanceof State] + guard.outgoing.filter[it.targetElement instanceof OffState];
	}
}