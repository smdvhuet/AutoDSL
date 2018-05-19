package info.scce.cinco.product.autoDSL.generator

import de.jabc.cinco.meta.core.utils.EclipseFileUtils
import de.jabc.cinco.meta.core.utils.projects.ProjectCreator
import de.jabc.cinco.meta.plugin.generator.runtime.IGenerator
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import java.util.ArrayList
import info.scce.cinco.product.autoDSL.rule.rule.BooleanGuardOutput
import info.scce.cinco.product.autoDSL.rule.rule.Comment
import graphmodel.Node
import info.scce.cinco.product.autoDSL.rule.rule.PIDController
import info.scce.cinco.product.autoDSL.rule.rule.SubRule
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleInputs
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs
import java.util.List

class RuleGenerator implements IGenerator<Rule> {
	var IFolder mainFolder
	
	override generate(Rule rule, IPath targetDir, IProgressMonitor monitor) {
		val ArrayList<String> srcFolders = new ArrayList<String>();
		srcFolders.add("src-gen")
		
		val IProject project = ProjectCreator.getProject(rule.eResource)
		mainFolder = project.getFolder("src-gen")
		
		if(isGuardRule(rule))
			generateGuardRule(mainFolder, rule)
		else if(isStateRule(rule))
			generateRule(mainFolder, rule)
		else if(isNeutralRule(rule))
			generateNeutralRule(mainFolder, rule)
		else
			System.out.println("Not implemented");
	}
	
//*********************************************************************************
//								GENERATE STATERULES
//*********************************************************************************
	private def generateRule(IFolder folder, Rule rule){
		var nodeGenerator = new NodeGenerator();
		EclipseFileUtils.writeToFile(folder.getFile(rule.name + ".h"), generateRuleHeader(rule, nodeGenerator))
	  	EclipseFileUtils.writeToFile(folder.getFile(rule.name + ".cpp"), generateRuleBody(rule, nodeGenerator))
	}
	
	private def generateRuleHeader(Rule rule, NodeGenerator nodeGenerator){
		var ArrayList<String> includes = new ArrayList(); 
		var ArrayList<String> privateMemberVars = new ArrayList();
		var ArrayList<String> publicMemberVars = new ArrayList();

		includes.add('"core/StateRule.h"');
		
		getGeneralDependencies(rule, includes, privateMemberVars, publicMemberVars)

		return '''	
		#ifndef AUTODSL_«rule.name.toUpperCase()»_H_
		#define AUTODSL_«rule.name.toUpperCase()»_H_
		«addIncludes(includes)»
			
		namespace AutoDSL{
		class «rule.name» : public ACCPlusPlus::StateRule{
		 public: 
		  «rule.name»();
		  ~«rule.name»();
		
		  void Execute(const ACCPlusPlus::IO::CarInputs &, ACCPlusPlus::IO::CarOutputs &);	
		  void onEntry();
		  void onExit();
		«addMemberVars("public", publicMemberVars)»
		«addMemberVars("private", privateMemberVars)»
		};
		} // namespace AutoDSL
		#endif // AUTODSL_«rule.name.toUpperCase()»_H_'''
	}
	
	private def generateRuleBody(Rule rule, NodeGenerator nodeGenerator){
		for(Node node : rule.operations){
			if(node.incoming.nullOrEmpty&&!(node instanceof Comment)){
				return
				'''	
				#include "«rule.name».h"
				
				#include "core/Utility.h"
				«addIncludes(rule.memories)»
				
				using namespace AutoDSL;
				
				«rule.name»::«rule.name»() : ACCPlusPlus::StateRule("«rule.name»")«IF rule.PIDControllers.length > 0»«FOR pid : rule.PIDControllers», pid«IDHasher.GetStringHash(pid.id)»(«pid.p», «pid.i», «pid.d»)«ENDFOR»«ENDIF»{}
				
				«rule.name»::~«rule.name»() {}
				
				void «rule.name»::Execute(const ACCPlusPlus::IO::CarInputs &input, ACCPlusPlus::IO::CarOutputs &output){
					«nodeGenerator.doSwitch(node)»
				}
					
				void «rule.name»::onEntry(){}
				
				void «rule.name»::onExit(){}'''
			}
		}
	}
	
//*********************************************************************************
//								GENERATE GUARDRULES
//*********************************************************************************		
	private def generateGuardRule(IFolder folder, Rule rule){
		var nodeGenerator = new NodeGenerator();
		EclipseFileUtils.writeToFile(folder.getFile(rule.name + ".h"), generateGuardRuleHeader(rule, nodeGenerator))
	  	EclipseFileUtils.writeToFile(folder.getFile(rule.name + ".cpp"), generateGuardRuleBody(rule, nodeGenerator))
	}
		
	private def generateGuardRuleHeader(Rule rule, NodeGenerator nodeGenerator){
		var ArrayList<String> includes = new ArrayList(); 
		var ArrayList<String> privateMemberVars = new ArrayList();
		var ArrayList<String> publicMemberVars = new ArrayList();

		includes.add('"core/GuardRule.h"');
		
		getGeneralDependencies(rule, includes, privateMemberVars, publicMemberVars)

		return '''	
		#ifndef AUTODSL_«rule.name.toUpperCase()»_H_
		#define AUTODSL_«rule.name.toUpperCase()»_H_
		«addIncludes(includes)»
			
		namespace AutoDSL{
		class «rule.name» : public ACCPlusPlus::GuardRule{
		 public: 
		  «rule.name»();
		  ~«rule.name»();
		
		  bool Execute(const ACCPlusPlus::IO::CarInputs &);	
		  void onEntry();
		  void onExit();
		«addMemberVars("public", publicMemberVars)»
		«addMemberVars("private", privateMemberVars)»
		};
		} // namespace AutoDSL
		#endif // AUTODSL_«rule.name.toUpperCase()»_H_'''
	}
	
	private def generateGuardRuleBody(Rule rule, NodeGenerator nodeGenerator){
		for(Node node : rule.operations){
			if(node.incoming.nullOrEmpty&&!(node instanceof Comment)){
				return
				'''	
				#include "«rule.name».h"
				
				#include "core/Utility.h"
				«addIncludes(rule.memories)»
				
				using namespace AutoDSL;
				
				«rule.name»::«rule.name»() : ACCPlusPlus::GuardRule("«rule.name»")«IF rule.PIDControllers.length > 0»«FOR pid : rule.PIDControllers», pid«IDHasher.GetStringHash(pid.id)»(«pid.p», «pid.i», «pid.d»)«ENDFOR»«ENDIF»{}
				
				«rule.name»::~«rule.name»() {}
				
				bool «rule.name»::Execute(const ACCPlusPlus::IO::CarInputs &input){
					«nodeGenerator.doSwitch(node)»
				}
				
				void «rule.name»::onEntry(){}
					
				void «rule.name»::onExit(){}'''
			}
		}
	}
	
//*********************************************************************************
//								GENERATE NEUTRALRULES
//*********************************************************************************		
	private def generateNeutralRule(IFolder folder, Rule rule){
		var nodeGenerator = new NodeGenerator();
		EclipseFileUtils.writeToFile(folder.getFile(rule.name + ".h"), generateNeutralRuleHeader(rule, nodeGenerator))
	  	EclipseFileUtils.writeToFile(folder.getFile(rule.name + ".cpp"), generateNeutralRuleBody(rule, nodeGenerator))
	}
		
	private def generateNeutralRuleHeader(Rule rule, NodeGenerator nodeGenerator){
		var ArrayList<String> includes = new ArrayList(); 
		var ArrayList<String> privateMemberVars = new ArrayList();
		var ArrayList<String> publicMemberVars = new ArrayList();

		includes.add('"core/NeutralRule.h"');
		
		getGeneralDependencies(rule, includes, privateMemberVars, publicMemberVars)

		return '''	
		#ifndef AUTODSL_«rule.name.toUpperCase()»_H_
		#define AUTODSL_«rule.name.toUpperCase()»_H_
		«addIncludes(includes)»
			
		namespace AutoDSL{
		class «rule.name» : public ACCPlusPlus::NeutralRule{
		 public: 
		  «rule.name»();
		  ~«rule.name»();
		
		  void Execute(const ACCPlusPlus::IO::CarInputs &);	
		  void onEntry();
		  void onExit();
		«addMemberVars("public", publicMemberVars)»
		«addMemberVars("private", privateMemberVars)»
		};
		} // namespace AutoDSL
		#endif // AUTODSL_«rule.name.toUpperCase()»_H_'''
	}
	
	private def generateNeutralRuleBody(Rule rule, NodeGenerator nodeGenerator){
		for(Node node : rule.operations){
			if(node.incoming.nullOrEmpty&&!(node instanceof Comment)){
				return
				'''	
				#include "«rule.name».h"
				
				#include "core/Utility.h"
				«addIncludes(rule.memories)»
				
				using namespace AutoDSL;
				
				«rule.name»::«rule.name»() : ACCPlusPlus::NeutralRule("«rule.name»")«IF rule.PIDControllers.length > 0»«FOR pid : rule.PIDControllers», pid«IDHasher.GetStringHash(pid.id)»(«pid.p», «pid.i», «pid.d»)«ENDFOR»«ENDIF»{}
				
				«rule.name»::~«rule.name»() {}
				
				void «rule.name»::Execute(const ACCPlusPlus::IO::CarInputs &input){
					«nodeGenerator.doSwitch(node)»
				}
				
				void «rule.name»::onEntry(){}
					
				void «rule.name»::onExit(){}'''
			}
		}
	}
	
//*********************************************************************************
//				FUNCTIONS FOR GENERATING A CLASSNAME
//*********************************************************************************		
	private def getSubRuleClassName(Rule rule){
		var name = "";
		if(!IDHasher.Contains(rule.id)){
		  	var String[] names = rule.eResource().getURI().lastSegment().split(".rule").get(0).split("_")
	
		  	name = getPrefix(rule);
		  	for(String n : names) {
		  		name = name + n.toFirstUpper
		  	}
		  	
		  	rule.name = name;
		  		  	
		  	//generate to file
		  	(new RuleGenerator()).generate(rule, null, null);
	  	}else{
	  		name = rule.name; 	
	  	}
	  	
	  	return name;
	}
	
	private def getPrefix(Rule rule){
		DSLGenerator.getPrefix(rule.eResource.URI.path, mainFolder)
	}
	
//*********************************************************************************
//				FUNCTIONS FOR NODES WITH OTHER GENERATED DEPENDENCIES
//*********************************************************************************	

	private def getMemories(Rule rule){
		val ArrayList<String> sharedMemories = new ArrayList<String>()
		val memoryGen = new SharedMemoryGenerator()
		for(it:rule.loadBooleans){
			val memoryName = '"'+memoryGen.generate(it.data.rootElement)+'.h"'  
			if(!sharedMemories.contains(memoryName)){
				sharedMemories.add(memoryName)
			}
		}
		for(it:rule.loadNumbers){
			val memoryName = '"'+memoryGen.generate(it.data.rootElement)+'.h"'  
			if(!sharedMemories.contains(memoryName)){
				sharedMemories.add(memoryName)
			}
		}
		for(it:rule.storedPIDControllers){
			val memoryName = '"'+memoryGen.generate(it.data.rootElement)+'.h"'  
			if(!sharedMemories.contains(memoryName)){
				sharedMemories.add(memoryName)
			}
		}
		for(it:rule.saveBooleans){
			val memoryName = '"'+memoryGen.generate(it.data.rootElement)+'.h"'  
			if(!sharedMemories.contains(memoryName)){
				sharedMemories.add(memoryName)
			}
		}
		for(it:rule.saveNumbers){
			val memoryName = '"'+memoryGen.generate(it.data.rootElement)+'.h"'  
			if(!sharedMemories.contains(memoryName)){
				sharedMemories.add(memoryName)
			}
		}
		return sharedMemories
	}
		
	private def getGeneralDependencies(Rule rule, List<String> includes, List<String> privateMemberVars, List<String> publicMemberVars){
		includes.add('"core/IO.h"');

		getPIDs(rule, includes, privateMemberVars)
		if(rule.exponentials.length > 0){includes.add("<math.h>")}
		getSubRules(rule, includes, privateMemberVars)
		getSubRuleInputs(rule, includes, publicMemberVars)
		getSubRuleOutputs(rule, includes, publicMemberVars)
	}
	
	private def getPIDs(Rule rule, List<String> includes, List<String> memberVars){
		//Generate contained pids
		if(rule.PIDControllers.length > 0){
			includes.add('"core/PID.h"');
			memberVars.add("//PIDControllers");
			for(PIDController pid : rule.PIDControllers){
				  memberVars.add("ACCPlusPlus::PID pid" + IDHasher.GetStringHash(pid.id));
			}
		}
	}
	
	private def getSubRules(Rule rule, List<String> includes, List<String> memberVars){
		//Generate contained subrules
		if(rule.subRules.length > 0){
			memberVars.add("//Subrules");
			for(SubRule subRule : rule.subRules){
				var subRuleNameClassName = getSubRuleClassName(subRule.rule);
				includes.add('"' + subRuleNameClassName + '.h"');
				memberVars.add(subRuleNameClassName + " " + IDHasher.GetStringHash(subRule.rule.id) + ";");
			}
		}
	}
	
	private def getSubRuleInputs(Rule rule, List<String> includes, List<String> memberVars){
		//Generate own (subrule) inputs
		if(rule.subRuleInputss.length > 0){
			memberVars.add("//SubRule inputs");
			
			for(SubRuleInputs input : rule.subRuleInputss){
				for(NumberSubOutput in : input.numberSubOutputs){
					var typeName = in.identifier;
					memberVars.add("double " + typeName + ";");
				}
				
				for(BooleanSubOutput in : input.booleanSubOutputs){
					var typeName = in.identifier;
					memberVars.add("bool " + typeName + ";");
				}
			}
		}
	}
	
	private def getSubRuleOutputs(Rule rule, List<String> includes, List<String> memberVars){
		//Generate own (subrule) outputs
		if(rule.subRuleOutputss.length > 0){
			if(rule.subRuleInputss.length > 0)
				memberVars.add("\n");
				
			memberVars.add("//SubRule outputs");
			
			for(SubRuleOutputs output : rule.subRuleOutputss){
				for(NumberSubInput out : output.numberSubInputs){
					var typeName = out.identifier;
					memberVars.add("double " + typeName + ";");
				}
				
				for(BooleanSubInput out : output.booleanSubInputs){
					var typeName = out.identifier;
					memberVars.add("bool " + typeName + ";");
				}
			}
		}
	}
	
	public static def boolean isGuardRule(Rule rule){
		return isPossibleGuardRule(rule) && !isPossibleStateRule(rule);
	}
	
	public static def boolean isPossibleGuardRule(Rule rule){
		var boolean isGuardRule = false;
		
		isGuardRule = isGuardRule || rule.allNodes.filter[it instanceof BooleanGuardOutput].length > 0;
		
		for(SubRule subRule : rule.subRules)
			isGuardRule = isGuardRule || isPossibleGuardRule(subRule.rule)
			
		return isGuardRule;
	}	
	
	public static def boolean isStateRule(Rule rule){
		return !isPossibleGuardRule(rule) && isPossibleStateRule(rule);
	}
	
	public static def boolean isPossibleStateRule(Rule rule){
		var boolean isStateRule = false;
		
		isStateRule = isStateRule || rule.operations.filter[it.numberCarOutputs.length > 0].length > 0
					|| rule.operations.filter[it.booleanCarOutputs.length > 0].length > 0
		
		for(SubRule subRule : rule.subRules)
			isStateRule = isStateRule || isPossibleStateRule(subRule.rule);
		
		return isStateRule;
	}
	
	public static def boolean isNeutralRule(Rule rule){
		return !isPossibleGuardRule(rule) && !isPossibleStateRule(rule)
	}
	
//*********************************************************************************
//					FUNCTIONS FOR WRITING TO GENERATED .h and .cpp	
//*********************************************************************************			
	private def addIncludes(List<String> includes){
		return '''
		«IF includes.length > 0»
		
		«ArrayToCharSequence("#include ", includes)»
		«ENDIF»
		'''		
	}
	
	private def addMemberVars(String accessSpecifier,List<String> privateMemberVars){
		return '''
		«IF privateMemberVars.length > 0»
		
		«accessSpecifier»:
		 «ArrayToCharSequence(privateMemberVars)»
		 «ENDIF»
		'''
	}
	
	private def ArrayToCharSequence(List<String> list){
		return'''
		«FOR l : list»
		«l»
		«ENDFOR»
		'''
	}
		
	private def ArrayToCharSequence(String prefix, List<String> list){
		return'''
		«FOR l : list»
		«prefix + l»
		«ENDFOR»
		'''
	}
	
}