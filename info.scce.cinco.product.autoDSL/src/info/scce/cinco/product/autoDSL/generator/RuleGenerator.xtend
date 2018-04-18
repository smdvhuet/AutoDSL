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
class RuleGenerator implements IGenerator<Rule> {
	var IFolder mainFolder
	var IFolder mainPackage
	
	override generate(Rule rule, IPath targetDir, IProgressMonitor monitor) {
		val ArrayList<String> srcFolders = new ArrayList<String>();
		srcFolders.add("src-gen")
		
		//val IProject project = ProjectCreator.createProject("Generated Product",srcFolders,null,null,null,null,monitor)
		val IProject project = ProjectCreator.getProject(rule.eResource)
		mainFolder = project.getFolder("src-gen")
		mainPackage = mainFolder.getFolder("info/scce/cinco/product")
		EclipseFileUtils.mkdirs(mainPackage,monitor)
		
		if(rule.allNodes.filter[it instanceof BooleanGuardOutput].length > 0)
			generateGuardRule(mainPackage, rule)
		else
			generateRule(mainPackage, rule)
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

				#include State;
				
				«IF nodeGenerator.importUtilityClass(rule)»#include Utility.h;«ENDIF»
				«IF nodeGenerator.importPIDClass(rule)»#include PID;«ENDIF»
				«IF nodeGenerator.importIOClass(rule)»#include IO;«ENDIF»
			
				namespace AutoDSL{
				
					class «rule.name» : public State{
						
						public: 
						«rule.name»();
						
						~«rule.name»();
						
						bool guard;
						void Execute(const IO::CarInputs &, IO::CarOutputs &);
						
						void onEntry();
						
						void onExit();
						
						inline string getName(){
							return "«rule.name»";
						}
						
						//PID Controllers
						
						private:
						«FOR pid : rule.PIDControllers»
						PID pid«IDHasher.GetStringHash(pid.id)»;
						«ENDFOR»
						
					};
				}
				'''
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
				
				«rule.name»::«rule.name»() {
					//PID Controllers
					«FOR pid : rule.PIDControllers»
					pid«IDHasher.GetStringHash(pid.id)» = PID(«pid.p», «pid.i», «pid.d»);
					«ENDFOR»
				}
				
				«rule.name»::~«rule.name»() {

				}
					
					
					void Execute(const IO::CarInputs &, IO::CarOutputs &){
						«node.doSwitch»
					}
					
					void onEntry(){
						
					}
					
					void onExit(){
						
					}
				}
				'''
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

				#include State;
				
				«IF nodeGenerator.importUtilityClass(rule)»#include Utility.h;«ENDIF»
				«IF nodeGenerator.importPIDClass(rule)»#include PID;«ENDIF»
				«IF nodeGenerator.importIOClass(rule)»#include IO;«ENDIF»
			
				namespace AutoDSL{
				
					class «rule.name» : public State{
						
						public: 
						«rule.name»();
						
						~«rule.name»();
						
						bool guard;
						bool Execute(const IO::CarInputs &);
						
						void onEntry();
						
						void onExit();
						
						inline string getName(){
							return "«rule.name»";
						}
						
						//PID Controllers
						
						private:
						«FOR pid : rule.PIDControllers»
						PID pid«IDHasher.GetStringHash(pid.id)»;
						«ENDFOR»
						
					};
				}
				'''
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
				
				«rule.name»::«rule.name»() {
					//PID Controllers
					«FOR pid : rule.PIDControllers»
					pid«IDHasher.GetStringHash(pid.id)» = PID(«pid.p», «pid.i», «pid.d»);
					«ENDFOR»
				}
				
				«rule.name»::~«rule.name»() {

				}
					
					
					void bool Execute(const IO::CarInputs &){
						«node.doSwitch»
					}
					
					void onEntry(){
						
					}
					
					void onExit(){
						
					}
				}
				'''
			}
		}
	}
}