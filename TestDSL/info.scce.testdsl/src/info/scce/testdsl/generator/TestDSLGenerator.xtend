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
import org.eclipse.xtext.xtext.generator.parser.antlr.splitting.simpleExpressions.OrExpression
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
import org.eclipse.emf.mwe2.language.mwe2.BooleanLiteral
import info.scce.testdsl.testDSL.Invariants
import java.util.List
import java.util.ArrayList

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class TestDSLGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
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
			tests.forEach[fsa.generateFile("Tests/" + it.name + ".h", generateTest(it))]
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
		class «test.name» : public ACCPlusPlus::Test{
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
	
	def generateExpression(Expression exp){
		switch exp{
			Or: return exp.left.generateExpression + " || " + exp.right.generateExpression
			And: return exp.left.generateExpression + " && " + exp.right.generateExpression
			Rel: return exp.left.generateExpression + " " + exp.op + " " + exp.right.generateExpression
			Add: return exp.left.generateExpression + " " + exp.op + " " + exp.right.generateExpression
			Mult: return exp.left.generateExpression + " " + exp.op + " " + exp.right.generateExpression
			Negation: return exp.op + exp.exprAtom.generateExpression
			IntLiteral: return exp.value
			BoolLiteral: return exp.value
			Subexpression: return "(" + exp.expr.generateExpression + ")"
			MonitorData: return "MonitorData"
			IntVarAtom: if(exp.diff == null) { return "gDebug_table.getColumn(" + exp.intvar + ")->values[gDebug_table.current_line - " + exp.diff.timeDiff + "]" }
						else {return "gDebug_table.getColumn(" + exp.intvar + ")->values[gDebug_table.current_line]"}
			BoolVarAtom: if(exp.diff == null) { return "gDebug_table.getColumn(" + exp.boolvar + ")->values[gDebug_table.current_line - " + exp.diff.timeDiff + "]" }
						else {return "gDebug_table.getColumn(" + exp.boolvar + ")->values[gDebug_table.current_line]"}
			VarAtom: return exp.^var.name + "()"
			StateComparison: return "StateComparison" 
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