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
	var IProgressMonitor monitor;
	var IPath targetDir;
	
	var IFolder mainFolder
	var IFolder corePackage
	var IFolder staticFolder
	
	var HashMap<Integer, String> knownRuleTypes =  new HashMap<Integer, String>()
	
	var HashMap<Integer, String> knownState = new HashMap<Integer, String>()
	var HashMap<Integer, String> knownGuard = new HashMap<Integer, String>()
	
	override generate(AutoDSL dsl, IPath targetDir, IProgressMonitor monitor) {
		knownRuleTypes.clear();
		
		knownState.clear();
		knownGuard.clear();
		
		this.targetDir = targetDir;
		this.monitor = monitor; 
		
		//val ArrayList<String> srcFolders = new ArrayList<String>();
		//srcFolders.add("src-gen")
		
		//val IProject project = ProjectCreator.createProject("Generated Product",srcFolders,null,null,null,null,monitor)
		val IProject project = ProjectCreator.getProject(dsl.eResource)
		mainFolder = project.getFolder("src-gen")
		EclipseFileUtils.mkdirs(mainFolder,monitor)
		corePackage = mainFolder.getFolder("core")
		EclipseFileUtils.mkdirs(corePackage,monitor)
		
		staticFolder = corePackage
		
		generateStatic()
		
		EclipseFileUtils.writeToFile(mainFolder.getFile("AutoDSL" + IDHasher.GetStringHash(dsl.id) + ".h"), generateStateMachineHeader(dsl))
		EclipseFileUtils.writeToFile(mainFolder.getFile("AutoDSL" + IDHasher.GetStringHash(dsl.id) + ".cpp"), generateStateMachineBody(dsl))
	}
	
	def generateStatic(){
		val thisBundle = "info.scce.cinco.product.autoDSL"
			
		copyStaticHeaderAndCpp(staticFolder, thisBundle, "cppcode/StateMachine")
		copyStaticHeaderAndCpp(staticFolder, thisBundle, "cppcode/State")
		copyStaticHeaderAndCpp(staticFolder, thisBundle, "cppcode/Guard")
		EclipseFileUtils.copyFromBundleToDirectory(thisBundle, "cppcode/Rule.h", staticFolder)
		EclipseFileUtils.copyFromBundleToDirectory(thisBundle, "cppcode/GuardRule.h", staticFolder)
			
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
	#ifndef AUTODSL_AUTODSL«IDHasher.GetStringHash(dsl.id)»_H_
	#define AUTODSL_AUTODSL«IDHasher.GetStringHash(dsl.id)»_H_
	
	#include "core/StateMachine.h"
	
	using namespace ACCPlusPlus;
	
	namespace AutoDSL{
	
	class AutoDSL«IDHasher.GetStringHash(dsl.id)» : public StateMachine{
	public:
	  AutoDSL«IDHasher.GetStringHash(dsl.id)»();
	  ~AutoDSL«IDHasher.GetStringHash(dsl.id)»();
		
	private:
	  «if(dsl.offStates.length() > 0) generateOffStateVars(dsl)»
	  
	  «if(dsl.states.length() > 0) generateStateVars(dsl)»
	  
	  «if(dsl.guards.length() > 0) generateGuardVars(dsl)»
	};
	} // namespace AutoDSL
	#endif // AUTODSL_AUTODSL«IDHasher.GetStringHash(dsl.id)»_H_
	'''
	
	private def generateStateMachineBody(AutoDSL dsl)'''
	#include "AutoDSL«IDHasher.GetStringHash(dsl.id)».h"
	
	using namespace AutoDSL;
	
	AutoDSL«IDHasher.GetStringHash(dsl.id)»::AutoDSL«IDHasher.GetStringHash(dsl.id)»(){
	  «if(dsl.offStates.length() > 0) initAllOffStates(dsl)»
	  
	  «if(dsl.states.length() > 0) initAllStates(dsl)»
	  
	  «if(dsl.guards.length() > 0) initAllGuards(dsl)»
	  
	  «if(dsl.allEdges.length > 0) initConnections(dsl)»
	  
	  «if(dsl.offStates.length > 0) chooseEntryState(dsl)»
	}
	
	AutoDSL«IDHasher.GetStringHash(dsl.id)»::~AutoDSL«IDHasher.GetStringHash(dsl.id)»(){
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
		«getRuleClassName(container.rule)»()
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
		«getRuleClassName(container.rule)»()
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
//								GENERATE RULE AND GUARD CLASS
//*********************************************************************************
	private def getRuleClassName(Rule rule){
	  var id = 	IDHasher.GetIntHash(rule.id);
	  var name = knownRuleTypes.get(id);
	  
	  if(name == null){
	  	var String[] names = rule.eResource().getURI().lastSegment().split(".rule").get(0).split("_")
	  	
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
}