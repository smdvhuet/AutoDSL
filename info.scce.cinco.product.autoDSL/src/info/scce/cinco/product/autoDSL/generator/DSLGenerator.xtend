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
		SharedMemoryGenerator.Clear();
		
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
		
		EclipseFileUtils.copyFromBundleToDirectory(thisBundle, "cppcode/ILogSink.h", staticFolder)
		EclipseFileUtils.copyFromBundleToDirectory(thisBundle, "cppcode/Logger.h", staticFolder)
		copyStaticHeaderAndCpp(staticFolder, thisBundle, "cppcode/LogMessage")
		copyStaticHeaderAndCpp(staticFolder, thisBundle, "cppcode/Debug")
		
		copyStaticHeaderAndCpp(staticFolder, thisBundle, "cppcode/PID")
	}
	
	def copyStaticHeaderAndCpp(IFolder folder, String bundle, String file){
		EclipseFileUtils.copyFromBundleToDirectory(bundle, file + ".h", folder)	
		EclipseFileUtils.copyFromBundleToDirectory(bundle, file + ".cpp", folder)
	}
//*********************************************************************************
//							GENERATE DSL HEADER AND BODY	
//*********************************************************************************		
	private def generateStateMachineHeader(AutoDSL dsl){'''
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
	}
	
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
	State* «getVarName(state)»;
	«ENDFOR»
	'''
	
	private def generateStateVars(AutoDSL dsl)'''
	//States
	«FOR state : dsl.states»
	State* «getVarName(state)»;
	«ENDFOR»		
	'''	
	
	private def generateGuardVars(AutoDSL dsl)'''
	//Guards
	«FOR guard : dsl.guards»
	Guard* «getVarName(guard)»;
	«ENDFOR»		
	'''	

//*********************************************************************************
//								DELETE VARIABLES	
//*********************************************************************************		
	private def deleteOffStateVars(AutoDSL dsl)'''
	//Delete OffStates
	«FOR state : dsl.offStates»
	«IF IDHasher.Contains(state.id)»
	delete «getVarName(state)»;
	«ENDIF»
	«ENDFOR»	
	'''
	
	private def deleteStateVars(AutoDSL dsl)'''
	//Delete states
	«FOR state : dsl.states»
	«IF IDHasher.Contains(state.id)»
	delete «getVarName(state)»;
	«ENDIF»
	«ENDFOR»	
	'''
	
	private def deleteGuardVars(AutoDSL dsl)'''
	//Delete guards
	«FOR guard : dsl.guards»
	«IF IDHasher.Contains(guard.id)»
	delete «getVarName(guard)»;
	«ENDIF»
	«ENDFOR»	
	'''

//*********************************************************************************
//								INITIALIZE VARIABLES	
//*********************************************************************************		
	private def initAllOffStates(AutoDSL dsl)'''
	//Initialize OffStates
	«FOR state : dsl.offStates»
	«getVarName(state)» = new State("Off", {});
	«ENDFOR»	
	'''
	
	private def initAllStates(AutoDSL dsl)'''
	//Initialize states
	«FOR state : dsl.states»
	«getVarName(state)» = new State(
	    "«state.label»", {
			«FOR container : state.componentNodes.sortBy[y] SEPARATOR ','»
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
	«getVarName(guard)» = new Guard(
	    "«guard.label»", {
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
	  return NamingUtilities.getTypeName(dsl, knownDSLTypes, mainFolder)
	}

	private def getRuleClassName(Rule rule){
	  rule.name = NamingUtilities.getTypeName(rule, knownRuleTypes, mainFolder)
	  (new RuleGenerator()).generate(rule, targetDir, monitor);
	  return rule.name;
	}
	
//*********************************************************************************
//								UTILITY FUNCTIONS
//*********************************************************************************	
	private def chooseEntryState(AutoDSL dsl)'''
	//Select entry state
	SetEntryState(«getStateName(dsl.offStates.get(0).id)»);
	'''
	
	private def getVarName(OffState state){
		return NamingUtilities.getOffStateVarName(state, knownState)
	}
	
	private def getVarName(State state){
		return NamingUtilities.getStateVarName(state, knownState)
	}
	
	private def getVarName(Guard guard){
		return NamingUtilities.getGuardVarName(guard, knownGuard)
	}
		
	//!use only if the state has already been registered
	private def getStateName(String id){
		return knownState.get(IDHasher.GetIntHash(id));
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
}