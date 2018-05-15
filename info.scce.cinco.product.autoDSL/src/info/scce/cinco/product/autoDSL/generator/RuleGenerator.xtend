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
		EclipseFileUtils.mkdirs(mainFolder,monitor)
		
		if(rule.allNodes.filter[it instanceof BooleanGuardOutput].length > 0)
			generateGuardRule(mainFolder, rule)
		else
			generateRule(mainFolder, rule)
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

		includes.add('"core/Rule.h"');
		
		getGeneralDependencies(rule, includes, privateMemberVars, publicMemberVars)

		return '''	
		#ifndef AUTODSL_«rule.name.toUpperCase()»_H_
		#define AUTODSL_«rule.name.toUpperCase()»_H_
		«addIncludes(includes)»
			
		namespace AutoDSL{
		class «rule.name» : public ACCPlusPlus::Rule{
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
				#include "SharedMemory.h"
				
				using namespace AutoDSL;
				
				«rule.name»::«rule.name»() : ACCPlusPlus::Rule("«rule.name»")«IF rule.PIDControllers.length > 0»«FOR pid : rule.PIDControllers», pid«IDHasher.GetStringHash(pid.id)»(«pid.p», «pid.i», «pid.d»)«ENDFOR»«ENDIF»{}
				
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
		
		  void Execute(const ACCPlusPlus::IO::CarInputs &, ACCPlusPlus::IO::CarOutputs &);	
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
				#include "SharedMemory.h"
				
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
		getPrefix(rule.eResource.URI.path)
	}
	
	private def getPrefix(String filePath){
		var projectName = mainFolder.project.name;
		var projectRelativeFilePath = filePath.substring(filePath.indexOf(projectName) + projectName.length + 1, filePath.length);
		var folders = projectRelativeFilePath.split("/");
		
		var prefix = "";
		for(var i = 0; i < folders.length - 1; i++){
			prefix += folders.get(i).toFirstUpper();
		}
		
		return prefix;
	}
	
//*********************************************************************************
//				FUNCTIONS FOR NODES WITH OTHER GENERATED DEPENDENCIES
//*********************************************************************************		
	private def getGeneralDependencies(Rule rule, List<String> includes, List<String> privateMemberVars, List<String> publicMemberVars){
		includes.add('"core/IO.h');

		getPIDs(rule, includes, privateMemberVars)
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
		
		«accessSpecifier»
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