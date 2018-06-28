/*
 * generated by Xtext 2.9.1
 */
package info.scce.testdsl.validation

import org.eclipse.xtext.validation.Check
import info.scce.testdsl.testDSL.Test
import info.scce.testdsl.testDSL.TestDSLPackage
import info.scce.testdsl.testDSL.TestInvariants
import info.scce.testdsl.testDSL.TestConditions
import info.scce.testdsl.testDSL.TestOptions
import info.scce.testdsl.testDSL.OptionDelay
import info.scce.testdsl.testDSL.OptionRunFrequency
import info.scce.testdsl.testDSL.OptionTimesToRun
import info.scce.testdsl.testDSL.Expression
import info.scce.testdsl.testDSL.*
import info.scce.cinco.product.autoDSL.sharedMemory.sharedmemory.StoredNumber
import info.scce.testdsl.validation.TestDSLValidator.ExpressionType

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class TestDSLValidator extends AbstractTestDSLValidator {
	
	@Check
	def checkTestFeatures(Test test) {
		var sawInvariants = false;
		var sawConditions = false;
		var sawOptions = false;
		for (f : test.testFeatures) {
			switch (f) {
				TestInvariants: {
					if (sawInvariants) {
						error('Cannot have multiple Invariants blocks', TestDSLPackage.Literals.TEST__TEST_FEATURES)
						return
					}
					sawInvariants = true;
				}
				
				TestConditions: {
					if (sawConditions) {
						error('Cannot have multiple Conditions blocks', TestDSLPackage.Literals.TEST__TEST_FEATURES)
						return
					}
					sawConditions = true;
				}
				
				TestOptions: {
					if (sawOptions) {
						error('Cannot have multiple Options blocks', TestDSLPackage.Literals.TEST__TEST_FEATURES)
						return
					}
					sawOptions = true;
				}
			}
		}

		if (!sawInvariants || !sawConditions) {
			error('Test requires Invariants and Conditions blocks', TestDSLPackage.Literals.TEST__TEST_FEATURES)
		}
	}
	
	@Check
	def checkOptionsFeatures(TestOptions opts) {
		var sawDelay = false;
		var sawRunFreq = false;
		var sawTimes = false;
		for (o : opts.options) {
			switch (o) {
				OptionDelay: {
					if (sawDelay) {
						error('Cannot have multiple Delays', TestDSLPackage.Literals.TEST_OPTIONS__OPTIONS)
						return
					}
					sawDelay = true;
				}
				
				OptionRunFrequency: {
					if (sawRunFreq) {
						error('Cannot have multiple RunFrequencys', TestDSLPackage.Literals.TEST_OPTIONS__OPTIONS)
						return
					}
					sawRunFreq = true;
				}
				
				OptionTimesToRun: {
					if (sawTimes) {
						error('Cannot have multiple TimeToRuns', TestDSLPackage.Literals.TEST_OPTIONS__OPTIONS)
						return
					}
					sawTimes = true;
				}
			}
		}
	}
	
	@Check
	def checkExpressionType(Invariants inv){
		for (var i = 0; i<inv.invs.size; i++) {
			var expr = inv.invs.get(i)
			if(expr.expressionType != ExpressionType.TBool){
				error("All Invariants must be Booleans", TestDSLPackage.Literals.INVARIANTS__INVS,i)
			}
		}
	}
	
	@Check
	def checkExpressionType(Variable variable){
		if(variable.expr.expressionType == ExpressionType.TUnknown){
			error("Invalid Expression. Can not resolve to Boolean or Number", TestDSLPackage.Literals.VARIABLE__EXPR)
		}
	}
	
	@Check
	def checkUniqueIDs(prog prog) {
		val idList = newArrayList()
		var name = ""
		for (var i = 0; i < prog.ops.size; i++) {
			var o = prog.ops.get(i)
			switch(o) {
				Monitor: {
					name = o.name;
					if (idList.contains(name)) {
						error(name + " is already in use.", TestDSLPackage.Literals.PROG__OPS, i)
						return
					}
					idList.add(name)
				}
				
				Test: {
					name = o.name;
					if (idList.contains(name)) {
						error(name + " is already in use.", TestDSLPackage.Literals.PROG__OPS, i)
						return 
					}
					idList.add(name)
				}
				
				Configuration: {
					name = o.name;
					if (idList.contains(name)) {
						error(name + " is already in use.", TestDSLPackage.Literals.PROG__OPS, i)
						return
					}
					idList.add(name)
				}
				
				Variable: {
					name = o.name;
					if (idList.contains(name)) {
						error(name + " is already in use.", TestDSLPackage.Literals.PROG__OPS, i)
						return
					}
					idList.add(name)
				}
			}
		}
	}
	
	def getExpressionType(Expression expr) {
		switch(expr) {
			Or:{
				if(expr.left.expressionType ==  ExpressionType.TBool && expr.right.expressionType == ExpressionType.TBool)
					return ExpressionType.TBool
				else
					return ExpressionType.TUnknown}
			And:{
				if(expr.left.expressionType ==  ExpressionType.TBool && expr.right.expressionType == ExpressionType.TBool)
					return ExpressionType.TBool
				else
					return ExpressionType.TUnknown
			}
			Rel:{
				if(((expr.op == "==")||(expr.op == "!=")) && expr.left.expressionType == expr.right.expressionType)
					return ExpressionType.TBool
				else if(expr.left.expressionType == ExpressionType.TNumber && expr.right.expressionType == ExpressionType.TNumber)
					return ExpressionType.TNumber
				else 
					return ExpressionType.TUnknown
			}
			Add:{
				if(expr.left.expressionType == ExpressionType.TNumber && expr.right.expressionType == ExpressionType.TNumber)
					return ExpressionType.TNumber
				else 
					return ExpressionType.TUnknown
			}
			Mult:{
				if(expr.left.expressionType == ExpressionType.TNumber && expr.right.expressionType == ExpressionType.TNumber)
					return ExpressionType.TNumber
				else 
					return ExpressionType.TUnknown
			}
			Negation:{
				if(expr.op == "!" && expr.exprAtom.expressionType == ExpressionType.TBool)
					return ExpressionType.TBool
				else if(expr.op == "-" && expr.exprAtom.expressionType == ExpressionType.TNumber)
					return ExpressionType.TNumber
				else 
					return ExpressionType.TUnknown
			}
			//Atoms
			IntLiteral, FloatLiteral: return ExpressionType.TNumber
			BoolLiteral: return ExpressionType.TBool
			Subexpression: return expr.expr.expressionType
			MonitorData:{
				if(expr.ref instanceof StoredNumber)
					return ExpressionType.TNumber
				else 
					return ExpressionType.TBool
			}
			IntVarAtom: return ExpressionType.TNumber
			BoolVarAtom: return ExpressionType.TBool
			VarAtom: return expr.^var.expr.expressionType
			StateComparison: return ExpressionType.TBool
			//default
			default: return ExpressionType.TUnknown
		}
	}
	
	public enum ExpressionType {
		TNumber, TBool, TUnknown;
	}
	
	def toString(ExpressionType typ){
		switch (typ){
			case ExpressionType.TNumber:return "Number"
			case ExpressionType.TBool:return "Boolean"
			default: return "UnknownType"
		}
	}
}