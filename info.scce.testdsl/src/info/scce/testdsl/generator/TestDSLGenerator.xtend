/*
 * generated by Xtext 2.9.1
 */
package info.scce.testdsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import info.scce.testdsl.testDSL.Configuration
import info.scce.testdsl.testDSL.Test
import info.scce.testdsl.testDSL.Expression
import info.scce.testdsl.testDSL.IntLiteral
import info.scce.testdsl.testDSL.BoolLiteral
import info.scce.testdsl.testDSL.Subexpression
import info.scce.testdsl.testDSL.IntVarAtom
import info.scce.testdsl.testDSL.MonitorData
import info.scce.testdsl.testDSL.BoolVarAtom
import info.scce.testdsl.testDSL.StateComparison
import info.scce.testdsl.testDSL.VarAtom
import info.scce.testdsl.testDSL.Or
import info.scce.testdsl.testDSL.And
import info.scce.testdsl.testDSL.Rel
import info.scce.testdsl.testDSL.Add
import info.scce.testdsl.testDSL.Mult
import info.scce.testdsl.testDSL.Negation
import info.scce.testdsl.testDSL.TestInvariants
import info.scce.testdsl.testDSL.TestConditions
import info.scce.testdsl.testDSL.TestOptions
import info.scce.testdsl.testDSL.TestFeature
import java.util.List
import java.util.ArrayList
import info.scce.testdsl.testDSL.OptionDelay
import info.scce.testdsl.testDSL.OptionTimesToRun
import info.scce.testdsl.testDSL.OptionRunFrequency
import info.scce.cinco.product.autoDSL.sharedMemory.sharedmemory.SharedMemory
import info.scce.testdsl.testDSL.FloatLiteral
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.IPath
import org.eclipse.core.resources.IFolder
import java.util.HashMap
import info.scce.testdsl.testDSL.State
import info.scce.testdsl.testDSL.CurrentState
import info.scce.testdsl.testDSL.StateRef

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class TestDSLGenerator extends AbstractGenerator {
	var IProgressMonitor monitor;
	var IPath targetDir;
	
	var IFolder mainFolder
	var IFolder staticFolder
	
	var HashMap<Integer, String> knownRuleTypes =  new HashMap<Integer, String>()
	var HashMap<Integer, String> knownDSLTypes =  new HashMap<Integer, String>()
	
	var HashMap<Integer, String> knownState = new HashMap<Integer, String>()
	var HashMap<Integer, String> knownGuard = new HashMap<Integer, String>()
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		System.out.printf("doGenerate is not being used.")
	}
	
	def generate(Resource resource, IPath targetDir, IProgressMonitor monitor, IFolder mainFolder, IFolder staticFolder, HashMap<Integer, String> knownRuleTypes, HashMap<Integer, String> knownDSLTypes,
		HashMap<Integer, String> knownState, HashMap<Integer, String> knownGuard){
		this.targetDir = targetDir;
		this.monitor = monitor;
		
		this.mainFolder = mainFolder;
		this.staticFolder = staticFolder;
		
		this.knownRuleTypes = knownRuleTypes;
		this.knownDSLTypes = knownDSLTypes;
		
		this.knownState = knownState;
		this.knownGuard = knownGuard;
		
		var configs = resource.allContents.filter(typeof(Configuration)).toList;
		
		if(configs == null){
			System.out.println("No configuration for monitoring found.")
			return;
		}
		
		if(configs.length != 1){
			System.out.println("There can only be one configuration for monitoring. Generation of monitoring aborted.")
			return;
		}
			
		var monitors = configs.get(0).monitors
		
		monitors.forEach[
			//tests.forEach[fsa.generateFile("tests/" + it.name + ".h", generateTest(it))]
		];
		
		System.out.println("Generated monitors.")
	}
	
	def generateTest(Test test){
		return '''
		#ifndef AUTODSL_MONITORING_«test.name.toUpperCase»_H_
		#define AUTODSL_MONITORING_«test.name.toUpperCase»_H_
		#include "core/Test.h"
		#include "core/Debug.h"
		
		namespace AutoDSL{
		namespace Monitoring {
		class «test.name» : public ACCPlusPlus::Monitoring::Test{
		public:
			«generateConstructor(test)»
		protected:
			«FOR t : test.testFeatures»
			«generateTest(t)»
			«ENDFOR»
			«generateVariables(test.testFeatures)»
		};
		} // namespace AutoDSL
		} // namespace Monitoring
		#endif // AUTODSL_MONITORING_«test.name.toUpperCase»_H_
		'''
	}
	
	def generateTest(TestFeature feature){
		if(feature instanceof TestInvariants){
			var invariants = (feature as TestInvariants).invariants;
			var String test = "";
			
			for(var i = 0; i < invariants.invs.length; i++){
				test += generateExpression(invariants.invs.get(i))
				
				if(i != invariants.invs.length - 1)
					test += " &&\n"
			}
			
			return "void Action" + "() override {\n  return " + test + ";\n}\n\n"
		}
		
		if(feature instanceof TestConditions){
			var conditions = (feature as TestConditions).conditions;
			var String test = "";
			
			for(var i = 0; i < conditions.invs.length; i++){
				test += generateExpression(conditions.invs.get(i))
				
				if(i != conditions.invs.length - 1)
					test += " &&\n"
			}
			
			return "void Condition" + "() override {\n  return " + test + ";\n}\n\n"
		}
		

	}
	
	def generateConstructor(Test test){
		var delay = 0;
		var timesToRun = -1;
		var runFrequence = 0;
		
		for(feature : test.testFeatures)
		if(feature instanceof TestOptions){
			var options = (feature as TestOptions).options;

			for(option : options){
				switch option{
					case OptionDelay: delay = (option as OptionDelay).delay
					case OptionTimesToRun: timesToRun = (option as OptionTimesToRun).timesToRun
					case OptionRunFrequency: runFrequence = (option as OptionRunFrequency).runFrequency
				}
			}
			
			return test.name + "() : ACCPlusPlus::Monitoring::Test(" + delay + ", " + timesToRun + ", " + runFrequence + "){}\n\n"
		}
	}
	
	def Object generateExpression(Expression exp){
		switch exp{
			Or: return exp.left.generateExpression + " || " + exp.right.generateExpression
			And: return exp.left.generateExpression + " && " + exp.right.generateExpression
			Rel: return exp.left.generateExpression + " " + exp.op + " " + exp.right.generateExpression
			Add: return exp.left.generateExpression + " " + exp.op + " " + exp.right.generateExpression
			Mult: return exp.left.generateExpression + " " + exp.op + " " + exp.right.generateExpression
			Negation: return exp.op + exp.exprAtom.generateExpression
			IntLiteral: return exp.value
			BoolLiteral: return exp.value
			FloatLiteral: return exp.value
			Subexpression: return "(" + exp.expr.generateExpression + ")"
			MonitorData: return generateMonitorData(exp)
			IntVarAtom: if(exp.diff != null) { return "gDebug_table.getColumn(" + exp.intvar + ")->values[gDebug_table.current_line - " + exp.diff.timeDiff + "].double_value" }
						else {return "gDebug_table.getColumn(" + exp.intvar + ")->values[gDebug_table.current_line].double_value"}
			BoolVarAtom: if(exp.diff != null) { return "gDebug_table.getColumn(" + exp.boolvar + ")->values[gDebug_table.current_line - " + exp.diff.timeDiff + "].double_value" }
						else {return "gDebug_table.getColumn(" + exp.boolvar + ")->values[gDebug_table.current_line].double_value"}
			VarAtom: return exp.^var.name + "()"
			StateComparison: return generateState(exp.leftState) + exp.op + generateState(exp.rightState)
		}
	}
	
	def generateMonitorData(MonitorData data){
		var sharedMemory = data.ref.eContainer.eContainer as SharedMemory
		"blub"//return "g" + SharedMemoryGenerator.getMemoryName(sharedMemory) + "_var." + data.ref.label
	}
	
	def String generateState(State state){
		switch state{
			CurrentState: return if(state.diff != null) {
				return 'gDebug_table.getColumn("Active state")->values[gDebug_table.current_line - ' + state.diff.timeDiff  + '].string_value'
			} else {
				return "gDebug_table.getColumn(" + '"' + "Active state" + '"' + ")->values[gDebug_table.current_line].string_value"
			}
			StateRef: return '"' + state.ref.label + '"' 
		}
	}

	def generateVariables(List<TestFeature> features){
		var varAtoms = new ArrayList<VarAtom>;
		
		// Find all references of type VarAtom and remove duplicates
		for(feature : features){
			varAtoms.addAll(feature.eAllContents.filter(typeof(VarAtom)).toList)
		}
		
		for(var i = 0; i < varAtoms.length; i++){
			for(var x = i + 1; x < varAtoms.length; x++){
				if(varAtoms.get(i).^var.name == varAtoms.get(x).^var.name){
					varAtoms.remove(x);
					x--;
				}		
			}
		}
		
		// Generate every intance of type VarAtom
		var String output = "";
		for(varAtom : varAtoms)
			output += generateVariable(varAtom)
			
		return output; 
	}
	
	def generateVariable(VarAtom exp){
		return "inline bool " + exp.^var.name + "(){\n  return " + generateExpression(exp.^var.expr) + ";\n}\n\n" 
	}
}