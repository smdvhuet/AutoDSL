package info.scce.cinco.product.autoDSL.generator

import de.jabc.cinco.meta.core.utils.EclipseFileUtils
import de.jabc.cinco.meta.core.utils.projects.ProjectCreator
import de.jabc.cinco.meta.plugin.generator.runtime.IGenerator
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL
import info.scce.cinco.product.autoDSL.autodsl.autodsl.OffState
import info.scce.cinco.product.autoDSL.autodsl.autodsl.State
import info.scce.cinco.product.autoDSL.autodsl.autodsl.Guard
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import java.util.HashMap

class DSLGenerator implements IGenerator<AutoDSL> {
	var IProgressMonitor monitor;
	var IPath targetDir;
	
	var IFolder mainFolder
	var IFolder staticFolder
	
	var HashMap<Integer, String> knownRuleTypes =  new HashMap<Integer, String>()
	var HashMap<Integer, String> knownDSLTypes =  new HashMap<Integer, String>()
	
	var HashMap<Integer, String> knownState = new HashMap<Integer, String>()
	var HashMap<Integer, String> knownGuard = new HashMap<Integer, String>()
	
	override generate(AutoDSL dsl, IPath targetDir, IProgressMonitor monitor) {
		IDHasher.Clear();
		
		knownRuleTypes.clear();
		knownDSLTypes.clear();
		
		knownState.clear();
		knownGuard.clear();
		
		this.targetDir = targetDir;
		this.monitor = monitor; 
		
		val IProject project = ProjectCreator.getProject(dsl.eResource)
		mainFolder = project.getFolder("src-gen")
		mainFolder.delete(true,monitor)
		EclipseFileUtils.mkdirs(mainFolder,monitor)
		staticFolder = mainFolder.getFolder("core")
		EclipseFileUtils.mkdirs(staticFolder,monitor)
		
		generateStatic()
		new SharedMemoryGenerator().generate(dsl,targetDir,monitor)
		
		EclipseFileUtils.writeToFile(mainFolder.getFile(getDSLClassName(dsl) + ".h"), generateStateMachineHeader(dsl))
		EclipseFileUtils.writeToFile(mainFolder.getFile(getDSLClassName(dsl) + ".cpp"), generateStateMachineBody(dsl))
	}
	
	def generateStatic(){
		val thisBundle = "info.scce.cinco.product.autoDSL"
			
		copyStaticHeaderAndCpp(staticFolder, thisBundle, "cppcode/StateMachine")
		copyStaticHeaderAndCpp(staticFolder, thisBundle, "cppcode/State")
		copyStaticHeaderAndCpp(staticFolder, thisBundle, "cppcode/Guard")
		EclipseFileUtils.copyFromBundleToDirectory(thisBundle, "cppcode/StateRule.h", staticFolder)
		EclipseFileUtils.copyFromBundleToDirectory(thisBundle, "cppcode/GuardRule.h", staticFolder)
		EclipseFileUtils.copyFromBundleToDirectory(thisBundle, "cppcode/NeutralRule.h", staticFolder)
			
		EclipseFileUtils.copyFromBundleToDirectory(thisBundle, "cppcode/IO.h", staticFolder)
		EclipseFileUtils.copyFromBundleToDirectory(thisBundle, "cppcode/IDGenerator.h", staticFolder)
		EclipseFileUtils.copyFromBundleToDirectory(thisBundle, "cppcode/Type.h", staticFolder)
		EclipseFileUtils.copyFromBundleToDirectory(thisBundle, "cppcode/Utility.h", staticFolder)
		
		copyStaticHeaderAndCpp(staticFolder, thisBundle, "cppcode/PID")
	}
	
	def copyStaticHeaderAndCpp(IFolder folder, String bundle, String file){
		EclipseFileUtils.copyFromBundleToDirectory(bundle, file + ".h", folder)	
		EclipseFileUtils.copyFromBundleToDirectory(bundle, file + ".cpp", folder)
	}
//*********************************************************************************
//							GENERATE DSL HEADER AND BODY	
//*********************************************************************************		
	private def generateStateMachineHeader(AutoDSL dsl)'''
	#ifndef AUTODSL_«getDSLClassName(dsl).toUpperCase()»_H_
	#define AUTODSL_«getDSLClassName(dsl).toUpperCase()»_H_
	
	#include "core/StateMachine.h"
	
	using namespace ACCPlusPlus;
	
	namespace AutoDSL{
	
	class «getDSLClassName(dsl)» : public StateMachine{
	public:
	  «getDSLClassName(dsl)»();
	  ~«getDSLClassName(dsl)»();
		
	private:
	  «if(dsl.offStates.length() > 0) generateOffStateVars(dsl)»
	  
	  «if(dsl.states.length() > 0) generateStateVars(dsl)»
	  
	  «if(dsl.guards.length() > 0) generateGuardVars(dsl)»
	};
	} // namespace AutoDSL
	#endif // AUTODSL_«getDSLClassName(dsl).toUpperCase()»H_
	'''
	
	private def generateStateMachineBody(AutoDSL dsl)'''
	#include "«getDSLClassName(dsl)».h"
	
	«getIncludes(dsl)»
	
	using namespace AutoDSL;
	
	«getDSLClassName(dsl)»::«getDSLClassName(dsl)»(){
	  «if(dsl.offStates.length() > 0) initAllOffStates(dsl)»
	  
	  «if(dsl.states.length() > 0) initAllStates(dsl)»
	  
	  «if(dsl.guards.length() > 0) initAllGuards(dsl)»
	  
	  «if(dsl.allEdges.length > 0) initConnections(dsl)»
	  
	  «if(dsl.offStates.length > 0) chooseEntryState(dsl)»
	}
	
	«getDSLClassName(dsl)»::~«getDSLClassName(dsl)»(){
	  «if(dsl.offStates.length() > 0) deleteOffStateVars(dsl)»
	 
	  «if(dsl.states.length() > 0) deleteStateVars(dsl)»
	  
	  «if(dsl.guards.length() > 0) deleteGuardVars(dsl)»
	}
	'''	
//*********************************************************************************
//								GENERATE VARIABLES	
//*********************************************************************************	
	private def generateOffStateVars(AutoDSL dsl)'''
	//OffStates
	«FOR state : dsl.offStates»
	State* «getStateName(state)»;
	«ENDFOR»
	'''
	
	private def generateStateVars(AutoDSL dsl)'''
	//States
	«FOR state : dsl.states»
	State* «getStateName(state)»;
	«ENDFOR»		
	'''	
	
	private def generateGuardVars(AutoDSL dsl)'''
	//Guards
	«FOR guard : dsl.guards»
	Guard* «getGuardName(guard)»;
	«ENDFOR»		
	'''	

//*********************************************************************************
//								DELETE VARIABLES	
//*********************************************************************************		
	private def deleteOffStateVars(AutoDSL dsl)'''
	//Delete OffStates
	«FOR state : dsl.offStates»
	«IF IDHasher.Contains(state.id)»
	delete «getStateName(state)»;
	«ENDIF»
	«ENDFOR»	
	'''
	
	private def deleteStateVars(AutoDSL dsl)'''
	//Delete states
	«FOR state : dsl.states»
	«IF IDHasher.Contains(state.id)»
	delete «getStateName(state)»;
	«ENDIF»
	«ENDFOR»	
	'''
	
	private def deleteGuardVars(AutoDSL dsl)'''
	//Delete guards
	«FOR guard : dsl.guards»
	«IF IDHasher.Contains(guard.id)»
	delete «getGuardName(guard)»;
	«ENDIF»
	«ENDFOR»	
	'''

//*********************************************************************************
//								INITIALIZE VARIABLES	
//*********************************************************************************		
	private def initAllOffStates(AutoDSL dsl)'''
	//Initialize OffStates
	«FOR state : dsl.offStates»
	«getStateName(state)» = new State({});
	«ENDFOR»	
	'''
	
	private def initAllStates(AutoDSL dsl)'''
	//Initialize states
	«FOR state : dsl.states»
	«getStateName(state)» = new State({
		«FOR container : state.componentNodes SEPARATOR ','»
		«IF container.rule != null»
		new «getRuleClassName(container.rule)»()
		«ENDIF»
		«ENDFOR»
	});
	«ENDFOR»	
	'''
	
	private def initAllGuards(AutoDSL dsl)'''
	//Initialize guards
	«FOR guard : dsl.guards»
	«getGuardName(guard)» = new Guard({
		«FOR container : guard.componentNodes SEPARATOR ','»
		«IF container.rule != null»
		new «getRuleClassName(container.rule)»()
		«ENDIF»
		«ENDFOR»
	});
	«ENDFOR»	
	'''
	
//*********************************************************************************
//						 SETUP STATE->GUARD->STATE CONNECTIONS	
//*********************************************************************************
	private def initConnections(AutoDSL dsl)'''
	//Setup connections (State -> Guard -> State)
	«FOR guard : dsl.guards»
	«FOR incoming : getIncomingEdges(guard)»
	«FOR outgoing : getOutgoingEdges(guard)»
	AddTransition(«getStateName(incoming.sourceElement.id)», «getStateName(outgoing.targetElement.id)», «getGuardName(guard.id)»);
	«ENDFOR»
	«ENDFOR»
	«ENDFOR»	
	'''
	
	private def getIncomingEdges(Guard guard){
		return guard.incoming.filter[it.sourceElement instanceof State] + guard.incoming.filter[it.sourceElement instanceof OffState];
	}
	
	private def getOutgoingEdges(Guard guard){
		return guard.outgoing.filter[it.targetElement instanceof State] + guard.outgoing.filter[it.targetElement instanceof OffState];
	}	
	
//*********************************************************************************
//								GENERATE CLASS NAMES
//*********************************************************************************
	private def getDSLClassName(AutoDSL dsl){
	  var id = 	IDHasher.GetIntHash(dsl.id);
	  var name = knownDSLTypes.get(id);
	  
	  if(name == null){
	  	var String[] names = dsl.eResource().getURI().lastSegment().split(".autodsl").get(0).split("_")
	  	
	  	name = getPrefix(dsl);
	  	for(String n : names) {
	  		name = name + n.toFirstUpper
	  	}
	  	
	  	//safe the dsltype name
	  	knownDSLTypes.put(IDHasher.GetIntHash(name), name)
	  }
		
	  return name;
	}


	private def getRuleClassName(Rule rule){
	  var id = 	IDHasher.GetIntHash(rule.id);
	  var name = knownRuleTypes.get(id);
	  
	  if(name == null){
	  	var String[] names = rule.eResource().getURI().lastSegment().split(".rule").get(0).split("_")

	  	name = getPrefix(rule);
	  	for(String n : names) {
	  		name = name + n.toFirstUpper
	  	}
	  	
	  	rule.name = name;
	  		  	
	  	//generate to file
	  	(new RuleGenerator()).generate(rule, targetDir, monitor);
	  	
	  	//safe the ruletype name
	  	knownRuleTypes.put(IDHasher.GetIntHash(rule.id), name)
	  }
		
	  return name;
	}
	
//*********************************************************************************
//								UTILITY FUNCTIONS
//*********************************************************************************	
	private def chooseEntryState(AutoDSL dsl)'''
	//Select entry state
	SetEntryState(«getStateName(dsl.offStates.get(0).id)»);
	'''

	private def getStateName(OffState state){
		var id = IDHasher.GetIntHash(state.id);
		var name = knownState.get(id);
		
		if(name == null){
			//construct new offstate name
			val postfix = "_";
			var label = "offstate";
			name = label + postfix;
			
			//try to use the user defined name. if it is already used add a counter to the name.
			var nameCount = 0;
			while(knownState.containsValue(name)){
				nameCount++;
				name = label + nameCount + postfix;
			}
			
			//safe the generated name 
			knownState.put(id, name);
		}
		
		return name;
	}
	
	private def getStateName(State state){
		var id = IDHasher.GetIntHash(state.id);
		var name = knownState.get(id);
		
		if(name == null){
			//construct new state name
			val prefix = "state_";
			val postfix = "_";
			
			//replace all spaces in the name
			var label = state.label;
			label = label.replaceAll(" ", "_");
			
			name = prefix + label + postfix;
			
			//try to use the user defined name. if it is already used add a counter to the name.
			var nameCount = 0;
			while(knownState.containsValue(name)){
				nameCount++;
				name = prefix + label + nameCount + postfix;
			}
			
			//safe the generated name 
			knownState.put(id, name);
		}
		
		return name;
	}
	
	//!use only if the state has already been registered
	private def getStateName(String id){
		return knownState.get(IDHasher.GetIntHash(id));
	}
	
	private def getGuardName(Guard guard){
		var id = IDHasher.GetIntHash(guard.id);
		var name = knownGuard.get(id);
		
		if(name == null){
			//construct new guard name
			val prefix = "guard_";
			val postfix = "_";
			
			//replace all spaces in the name
			var label = guard.label;
			label = label.replaceAll(" ", "_");
			
			name = prefix + label + postfix;
			
			//try to use the user defined name. if it is already used add a counter to the name.
			var nameCount = 0;
			while(knownGuard.containsValue(name)){
				nameCount++;
				name = prefix + label + nameCount + postfix;
			}
			
			//safe the generated name 
			knownGuard.put(id, name);
		}
		
		return name;
	}
	
	//!use only if the guard has already been registered
	private def getGuardName(String id){
		return knownGuard.get(IDHasher.GetIntHash(id));
	}
	
	private def getIncludes(AutoDSL dsl){
		initAllOffStates(dsl)
		initAllStates(dsl)
		initAllGuards(dsl)
		
		return '''
		«FOR ruleName : knownRuleTypes.values»
		#include "«ruleName».h"
		«ENDFOR»
		'''
	}
	
	private def getPrefix(AutoDSL dsl){
		getPrefix(dsl.eResource.URI.path, mainFolder)
	}
	
	private def getPrefix(Rule rule){
		getPrefix(rule.eResource.URI.path, mainFolder)
	}
	
	public static  def getPrefix(String filePath, IFolder mainFolder){
		var projectName = mainFolder.project.name;
		var projectRelativeFilePath = filePath.substring(filePath.indexOf(projectName) + projectName.length + 1, filePath.length);
		var folders = projectRelativeFilePath.split("/");
		
		var prefix = "";
		for(var i = 0; i < folders.length - 1; i++){
			prefix += folders.get(i).toFirstUpper();
		}
		
		return prefix;
	}
	
}