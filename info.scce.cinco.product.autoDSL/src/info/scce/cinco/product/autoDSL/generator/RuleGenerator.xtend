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
import java.util.Iterator
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput

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
		for(Node node : rule.operations){
			if(node.incoming.nullOrEmpty&&!(node instanceof Comment)){
				return
				'''	
			#ifndef AUTODSL_«rule.name.toUpperCase()»_H_
			#define AUTODSL_«rule.name.toUpperCase()»_H_
			
			#include "core/Rule.h"
			#include "core/IO.h"
			«IF nodeGenerator.importPIDClass(rule)»#include "core/PID.h"«ENDIF»
			«IF nodeGenerator.importUtilityClass(rule)»#include "core/Utility.h"«ENDIF»
			
			namespace AutoDSL{
			class «rule.name» : public ACCPlusPlus::Rule{
			 public: 
			  «rule.name»();
			  ~«rule.name»();
			
			  void Execute(const ACCPlusPlus::IO::CarInputs &, ACCPlusPlus::IO::CarOutputs &);	
			  void onEntry();
			  void onExit();
						
			  inline std::string getName(){
			    return "«rule.name»";
			  }
						
			 private:
			  «IF nodeGenerator.importUtilityClass(rule)»//PID Controllers«ENDIF»
			  «FOR pid : rule.PIDControllers»
			  ACCPlusPlus::PID pid«IDHasher.GetStringHash(pid.id)»;
			  «ENDFOR»	
			};
			} // namespace AutoDSL
			#endif // AUTODSL_«rule.name.toUpperCase()»_H_'''
			}
		}
	}
	
	private def generateRuleBody(Rule rule, NodeGenerator nodeGenerator){
		for(Node node : rule.operations){
			if(node.incoming.nullOrEmpty&&!(node instanceof Comment)){
				return
				'''	
				#include "«rule.name».h"
				
				using namespace AutoDSL;
				
				«rule.name»::«rule.name»() : ACCPlusPlus::Rule()
					«IF nodeGenerator.importUtilityClass(rule)»//PID Controllers«ENDIF»
					«FOR pid : rule.PIDControllers»
					, pid«IDHasher.GetStringHash(pid.id)»(«pid.p», «pid.i», «pid.d»)
					«ENDFOR»{}
				
				«rule.name»::~«rule.name»() {}
				
				void «rule.name»::Execute(const ACCPlusPlus::IO::CarInputs & input, ACCPlusPlus::IO::CarOutputs & output){
					«nodeGenerator.generateSubRulePorts(rule)»
					
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
		for(Node node : rule.operations){
			//TODO: Muss hier ein anderer Klassenname verwendet werden?
			if(node.incoming.nullOrEmpty&&!(node instanceof Comment)){
				return
				'''	
				#ifndef AUTODSL_«rule.name.toUpperCase»_H_
				#define AUTODSL_«rule.name.toUpperCase»_H_
				
				#include "core/GuardRule.h"
				#include "core/IO.h"
				«IF nodeGenerator.importPIDClass(rule)»#include "core/PID.h"«ENDIF»
				«IF nodeGenerator.importUtilityClass(rule)»#include "core/Utility.h"«ENDIF»
			
				namespace AutoDSL{
				class «rule.name» : public ACCPlusPlus::GuardRule{
				 public: 
				  «rule.name»();
				  ~«rule.name»();

				  bool Execute(const ACCPlusPlus::IO::CarInputs &);
				  void onEntry();
				  void onExit();

				  inline std::string getName(){
				    return "«rule.name»";
				  }
			
			    private:
				 «IF nodeGenerator.importUtilityClass(rule)»//PID Controllers«ENDIF»
				 «FOR pid : rule.PIDControllers»
				 ACCPlusPlus::PID pid«IDHasher.GetStringHash(pid.id)»;
				 «ENDFOR»
				};
				} // AutoDSL
				#endif // AUTODSL_«rule.name.toUpperCase»_H_'''
			}
		}
	}
	
	private def generateGuardRuleBody(Rule rule, NodeGenerator nodeGenerator){
		for(Node node : rule.operations){
			if(node.incoming.nullOrEmpty&&!(node instanceof Comment)){
				return
				'''	
				#include "«rule.name».h"
				
				using namespace AutoDSL;
				
				«rule.name»::«rule.name»() : ACCPlusPlus::GuardRule()
					«IF nodeGenerator.importUtilityClass(rule)»//PID Controllers«ENDIF»
					«FOR pid : rule.PIDControllers»
					, pid«IDHasher.GetStringHash(pid.id)»(«pid.p», «pid.i», «pid.d»)
					«ENDFOR»{}
				
				«rule.name»::~«rule.name»() {}
				
				bool «rule.name»::Execute(const ACCPlusPlus::IO::CarInputs & input){
					«nodeGenerator.generateSubRulePorts(rule)»
					
					«nodeGenerator.doSwitch(node)»
				}
				
				void «rule.name»::onEntry(){}
					
				void «rule.name»::onExit(){}'''
			}
		}
	}
}