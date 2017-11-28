package info.scce.cinco.product.autoDSL.generator

import graphmodel.Node
import info.scce.cinco.product.autoDSL.rule.rule.Addition
import info.scce.cinco.product.autoDSL.rule.rule.Comment
import info.scce.cinco.product.autoDSL.rule.rule.Decision
import info.scce.cinco.product.autoDSL.rule.rule.Input
import info.scce.cinco.product.autoDSL.rule.rule.Less
import info.scce.cinco.product.autoDSL.rule.rule.LessOrEqual
import info.scce.cinco.product.autoDSL.rule.rule.LogicalAnd
import info.scce.cinco.product.autoDSL.rule.rule.LogicalOr
import info.scce.cinco.product.autoDSL.rule.rule.Maximum
import info.scce.cinco.product.autoDSL.rule.rule.Minimum
import info.scce.cinco.product.autoDSL.rule.rule.Multiplication
import info.scce.cinco.product.autoDSL.rule.rule.Negation
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutputNode
import info.scce.cinco.product.autoDSL.rule.rule.NumberStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.PIDController
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.Subtraction
import info.scce.cinco.product.autoDSL.rule.rule.util.RuleSwitch
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarInput

//TODO Adapt to new alterations in mgl

class NodeGenerator extends RuleSwitch<CharSequence> {
	
	def generate(Rule rule){
		rule.caseRule
	}
	
	
	override caseRule(Rule rule){
		for(Node node : rule.operations){
			if(node.incoming.nullOrEmpty&&!(node instanceof Comment)){
				return
				'''
				public class Rule{
					public void applyRule(){
						«node.doSwitch»
					}
					
					private float min(float[] values){
						float result = values[0];
						for(int i = 1; i < values.length; i++){
							float x = values[i];
							if(x < result){
								result = values[i];
							}
						}
						return result;
					}
					
					private float max(float[] values){
						float result = values[0];
						for(int i = 1; i < values.length; i++){
							float x = values[i];
							if(x > result){
								result = values[i];
							}
						}
						return result;
					}
				}
				'''
			}
		}
	}
	
	//TODO Connect PID to input and make pid global
	override casePIDController(PIDController op)'''
		//PID Controller
		PID pid«op.id» = new PID(«op.p», «op.i», «op.d»);
		double «op.id» = pid«op.id».calc(0, 0, 0);
		
		«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseNegation(Negation op)'''
	//Negation Operator
	boolean «op.booleanOutputs.head.id» = !«op.booleanInputs.head.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseAddition(Addition op)'''
	//Addition Operator
	float «op.outputs.head.id» = «FOR input : op.inputs SEPARATOR '+'»«
									input.referenceInput»«
								ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseMultiplication(Multiplication op)'''
	//Multiplication Operator
	float «op.outputs.head.id» = «FOR input : op.inputs SEPARATOR '*'»«
									input.referenceInput»«
								ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseMaximum(Maximum op)'''
	//Max Operator
	float[] «op.id» = {«FOR  input : op.inputs SEPARATOR ','»«
						input.referenceInput»«
						ENDFOR»}
	float «op.outputs.head.id» = max(«op.id»);
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseMinimum(Minimum op)'''
	//Min Operator
	float[] «op.id» = {«FOR  input : op.inputs SEPARATOR ','»«
							input.referenceInput»«
						ENDFOR»}
	float «op.outputs.head.id» = min(«op.id»);
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLogicalAnd(LogicalAnd op)'''
	//And Operator
	boolean «op.outputs.head.id» = «FOR in : op.inputs SEPARATOR '&&'»«
										in.referenceInput»«
									ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLogicalOr(LogicalOr op)'''
	//Or Operator
	boolean «op.outputs.head.id» = «FOR in : op.inputs SEPARATOR '||'»«
											in.referenceInput»«
										ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseSubtraction(Subtraction op)'''
	//Substraction Operator
	float «op.outputs.head.id» = «op.inputs.head.referenceInput» - «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLess(Less op)'''
	//Less Operator
	boolean «op.outputs.head.id» = «op.inputs.head.referenceInput» < «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLessOrEqual(LessOrEqual op)'''
	//LessOrEqual Operator
	boolean «op.outputs.head.id» = «op.inputs.head.referenceInput» <= «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseDecision(Decision d)'''
	if(«d.booleanInputs.head.referenceInput»){
		«d.getSuccessors.head.doSwitch»
	}«IF d.successors.size>1» else{
		«d.getSuccessors.last.doSwitch»
	}«ENDIF»
	'''
	
	override caseNumberOutputNode(NumberOutputNode out)'''
	«out.numberCarOutputs.head.outputtype.toString» = «out.numberInputs.head.referenceInput»;
	«if(!out.getSuccessors.nullOrEmpty)out.getSuccessors.head.doSwitch»
	'''
	
	def CaseNode(Node n)'''/*Node «n.toString» not found*/
	«if(!n.getSuccessors.nullOrEmpty)n.getSuccessors.head.doSwitch»
	'''
	
	def referenceInput(Input in){
		switch in{
			NumberStaticInput :	in.staticValue
			NumberCarInput :	in.inputtype.toString
			default :	if(in.predecessors.nullOrEmpty){
							"/*input not a reference*/"
						}else{
							in.predecessors.head.id
						}
		}	
	}
}