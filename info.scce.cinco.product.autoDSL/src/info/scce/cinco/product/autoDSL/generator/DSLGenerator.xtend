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
	var IFolder staticFolder
	
	var HashMap<Integer, String> knownRuleTypes =  new HashMap<Integer, String>()
	
	override generate(AutoDSL dsl, IPath targetDir, IProgressMonitor monitor) {
		knownRuleTypes.clear();
		
		val ArrayList<String> srcFolders = new ArrayList<String>();
		srcFolders.add("src-gen")
		
		val IProject project = ProjectCreator.createProject("Generated Product",srcFolders,null,null,null,null,monitor)
		mainFolder = project.getFolder("src-gen")
		mainPackage = mainFolder.getFolder("info/scce/cinco/product")
		EclipseFileUtils.mkdirs(mainPackage,monitor)
		corePackage = mainFolder.getFolder("info/scce/cinco/product/core")
		EclipseFileUtils.mkdirs(corePackage,monitor)
		
		staticFolder = corePackage
		
		generateStatic()
		
		EclipseFileUtils.writeToFile(mainPackage.getFile("AutoDSL" + IDHasher.GetStringHash(dsl.id) + ".h"), generateStateMachineHeader(dsl))
		EclipseFileUtils.writeToFile(mainPackage.getFile("AutoDSL" + IDHasher.GetStringHash(dsl.id) + ".cpp"), generateStateMachineBody(dsl))
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
	def generateStateMachineHeader(AutoDSL dsl)'''
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
	
	def generateStateMachineBody(AutoDSL dsl)'''
	#include AutoDSL«IDHasher.GetStringHash(dsl.id)».h"
	
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
	def generateOffStateVars(AutoDSL dsl)'''
	//OffStates
	«FOR state : dsl.offStates»
	State* state«IDHasher.GetIntHash(state.id)»_;
	«ENDFOR»
	'''
	
	def generateStateVars(AutoDSL dsl)'''
	//States
	«FOR state : dsl.states»
	State* state«IDHasher.GetIntHash(state.id)»_;
	«ENDFOR»		
	'''	
	
	def generateGuardVars(AutoDSL dsl)'''
	//Guards
	«FOR guard : dsl.guards»
	Guard* guard«IDHasher.GetIntHash(guard.id)»_;
	«ENDFOR»		
	'''	

//*********************************************************************************
//								DELETE VARIABLES	
//*********************************************************************************		
	def deleteOffStateVars(AutoDSL dsl)'''
	//Delete OffStates
	«FOR state : dsl.offStates»
	«IF IDHasher.Contains(state.id)»
	delete state«IDHasher.GetIntHash(state.id)»_;
	«ENDIF»
	«ENDFOR»	
	'''
	
	def deleteStateVars(AutoDSL dsl)'''
	//Delete states
	«FOR state : dsl.states»
	«IF IDHasher.Contains(state.id)»
	delete state«IDHasher.GetIntHash(state.id)»_;
	«ENDIF»
	«ENDFOR»	
	'''
	
	def deleteGuardVars(AutoDSL dsl)'''
	//Delete guards
	«FOR guard : dsl.guards»
	«IF IDHasher.Contains(guard.id)»
	delete guard«IDHasher.GetIntHash(guard.id)»_;
	«ENDIF»
	«ENDFOR»	
	'''

//*********************************************************************************
//								INITIALIZE VARIABLES	
//*********************************************************************************		
	def initAllOffStates(AutoDSL dsl)'''
	//Initialize OffStates
	«FOR state : dsl.offStates»
	state«IDHasher.GetIntHash(state.id)»_ = new State({});
	«ENDFOR»	
	'''
	
	def initAllStates(AutoDSL dsl)'''
	//Initialize states
	«FOR state : dsl.states»
	state«IDHasher.GetIntHash(state.id)»_ = new State({
		«FOR container : state.componentNodes SEPARATOR ','»
		«IF container.rule != null»
		«generateRuleType(container.rule)»()
		«ENDIF»
		«ENDFOR»
	});
	«ENDFOR»	
	'''
	
	def initAllGuards(AutoDSL dsl)'''
	//Initialize guards
	«FOR guard : dsl.guards»
	guard«IDHasher.GetIntHash(guard.id)»_ = new Guard({
		«FOR container : guard.componentNodes SEPARATOR ','»
		«IF container.rule != null»
		«generateRuleType(container.rule)»()
		«ENDIF»
		«ENDFOR»
	});
	«ENDFOR»	
	'''
	
//*********************************************************************************
//						 SETUP STATE->GUARD->STATE CONNECTIONS	
//*********************************************************************************
	def initConnections(AutoDSL dsl)'''
	//Setup connections (State -> Guard -> State)
	«FOR guard : dsl.guards»
	«FOR incoming : getIncomingEdges(guard)»
	«FOR outgoing : getOutgoingEdges(guard)»
	AddTransition(state«IDHasher.GetIntHash(incoming.id)»_, state«IDHasher.GetIntHash(outgoing.id)»_, guard«IDHasher.GetIntHash(guard.id)»_)
	«ENDFOR»
	«ENDFOR»
	«ENDFOR»	
	'''
	
	def getIncomingEdges(Guard guard){
		return guard.incoming.filter[it.sourceElement instanceof State] + guard.incoming.filter[it.sourceElement instanceof OffState];
	}
	
	def getOutgoingEdges(Guard guard){
		return guard.outgoing.filter[it.targetElement instanceof State] + guard.outgoing.filter[it.targetElement instanceof OffState];
	}	
	
//*********************************************************************************
//								GENERATE RULE CLASS
//*********************************************************************************
	def generateRuleType(Rule rule){
	  var String ruleName = knownRuleTypes.get(IDHasher.GetIntHash(rule.id))
	  if(ruleName == null){
	  	var String[] names = rule.eResource().getURI().lastSegment().split(".rule").get(0).split("_")
	  	rule.name = ""
	  	for(String name: names) {
	  		rule.name = rule.name + name.toFirstUpper
	  	}
	  	EclipseFileUtils.writeToFile(mainPackage.getFile(rule.name + ".java"), new NodeGenerator().generate(rule))
	  	knownRuleTypes.put(IDHasher.GetIntHash(rule.id), rule.name)
	  	ruleName = rule.name	
	  }
	  
	  return '''«ruleName»'''
	}
	
//*********************************************************************************
//								UTILITY FUNCTIONS
//*********************************************************************************	
	def chooseEntryState(AutoDSL dsl)'''
	//Select entry state
	SetEntryState(states«IDHasher.GetIntHash(dsl.offStates.get(0).id)»_);
	'''
}