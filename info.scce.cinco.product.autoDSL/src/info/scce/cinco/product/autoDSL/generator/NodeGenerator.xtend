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
import info.scce.cinco.product.autoDSL.rule.rule.NumberStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.PIDController
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.Subtraction
import info.scce.cinco.product.autoDSL.rule.rule.util.RuleSwitch
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarInput
import info.scce.cinco.product.autoDSL.rule.rule.DirectNumberOutput
import info.scce.cinco.product.autoDSL.rule.rule.ControlFlowDecisionTrue
import info.scce.cinco.product.autoDSL.rule.rule.ControlFlowDecisionFalse
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.DirectBooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.Output
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanGuardOutput
import info.scce.cinco.product.autoDSL.rule.rule.Greater
import info.scce.cinco.product.autoDSL.rule.rule.GreaterOrEqual
import info.scce.cinco.product.autoDSL.rule.rule.Division

class NodeGenerator extends RuleSwitch<CharSequence> {
	
	def generate(Rule rule){
		rule.caseRule
	}
	
	override caseRule(Rule rule){
		for(Node node : rule.operations){
			if(node.incoming.nullOrEmpty&&!(node instanceof Comment)){
				return
				'''	
				package info.scce.cinco.product;
				
				import info.scce.cinco.core.State;
				import info.scce.cinco.core.PID;
				«IF importUtilityClass(rule)»import info.scce.cinco.core.Utility; «ENDIF»
				
				public class «rule.name» extends State{
					
					
					//PID Controllers
					«FOR pid : rule.PIDControllers»
					private PID pid«IDHasher.GetStringHash(pid.id)» = new PID(«pid.p», «pid.i», «pid.d»);
					«ENDFOR»
					
					public void Execute(){
						«node.doSwitch»
					}
					
					public void onEntry(){
						
					}
					
					public void onExit(){
						
					}
					
					public String getName(){
						return "«rule.name»";
					}
				}
				'''
			}
		}
	}
	
	//TODO get dT for PID
	override casePIDController(PIDController op)'''
		//PID Controller
		double «op.outputs.head.referenceOutput» = pid«IDHasher.GetStringHash(op.id)».calc(«op.inputs.head.referenceInput», «op.inputs.last.referenceInput», 0.1);
		
		«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseNegation(Negation op)'''
	//Negation Operator
	boolean «IDHasher.GetStringHash(op.booleanOutputs.head.id)» = !«op.booleanInputs.head.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseAddition(Addition op)'''
	//Addition Operator
	double «op.outputs.head.referenceOutput» = «FOR input : op.inputs SEPARATOR '+'»«
									input.referenceInput»«
								ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseMultiplication(Multiplication op)'''
	//Multiplication Operator
	double «op.outputs.head.referenceOutput» = «FOR input : op.inputs SEPARATOR '*'»«
									input.referenceInput»«
								ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseMaximum(Maximum op)'''
	//Max Operator
	double[] «IDHasher.GetStringHash(op.id)» = {«FOR  input : op.inputs SEPARATOR ','»«
						input.referenceInput»«
						ENDFOR»};
	double «op.outputs.head.referenceOutput» = Utility.max(«IDHasher.GetStringHash(op.id)»);
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseMinimum(Minimum op)'''
	//Min Operator
	double[] «IDHasher.GetStringHash(op.id)» = {«FOR  input : op.inputs SEPARATOR ','»«
							input.referenceInput»«
						ENDFOR»};
	double «op.outputs.head.referenceOutput» = Utility.min(«IDHasher.GetStringHash(op.id)»);
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLogicalAnd(LogicalAnd op)'''
	//And Operator
	boolean «op.outputs.head.referenceOutput» = «FOR in : op.inputs SEPARATOR '&&'»«
										in.referenceInput»«
									ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLogicalOr(LogicalOr op)'''
	//Or Operator
	boolean «op.outputs.head.referenceOutput» = «FOR in : op.inputs SEPARATOR '||'»«
											in.referenceInput»«
										ENDFOR»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseSubtraction(Subtraction op)'''
	//Substraction Operator
	double «op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» - «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseDivision(Division op)'''
	//Division Operator
	double «op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» / «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLess(Less op)'''
	//Less Operator
	boolean «op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» < «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseLessOrEqual(LessOrEqual op)'''
	//LessOrEqual Operator
	boolean «op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» <= «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseGreater(Greater op)'''
	//Greater Operator
	boolean «op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» > «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseGreaterOrEqual(GreaterOrEqual op)'''
	//GreaterOrEqual Operator
	boolean «op.outputs.head.referenceOutput» = «op.inputs.head.referenceInput» >= «op.inputs.last.referenceInput»;
	«if(!op.getSuccessors.nullOrEmpty)op.getSuccessors.head.doSwitch»
	'''
	
	override caseDecision(Decision d)'''
	if(«d.booleanInputs.head.referenceInput»){
		«d.outgoing.filter(ControlFlowDecisionTrue).head.getTargetElement.doSwitch»
	}«IF !d.outgoing.filter(ControlFlowDecisionFalse).nullOrEmpty» else{
		«d.outgoing.filter(ControlFlowDecisionFalse).head.getTargetElement.doSwitch»
	}«ENDIF»
	'''
	
	override caseDirectNumberOutput(DirectNumberOutput out)'''
	//Number Output
	«out.numberCarOutputs.head.referenceOutput» = «out.numberInputs.head.referenceInput»;
	«if(!out.getSuccessors.nullOrEmpty)out.getSuccessors.head.doSwitch»
	'''
	
	override caseDirectBooleanOutput(DirectBooleanOutput out)'''
	//Boolean Output
	«out.booleanCarOutputs.head.referenceOutput» = «out.booleanInputs.head.referenceInput»;
	«if(!out.getSuccessors.nullOrEmpty)out.getSuccessors.head.doSwitch»
	'''	
	override caseBooleanGuardOutput(BooleanGuardOutput out)'''
	//Guard Output
	guard = «out.booleanInputs.head.referenceInput»;
	'''
	
	override caseNode(Node n)'''/*Node «n.toString» not found*/
	«if(!n.getSuccessors.nullOrEmpty)n.getSuccessors.head.doSwitch»
	'''

	
	def referenceInput(Input in){
		switch in{
			NumberStaticInput :	in.staticValue
			NumberCarInput :	"in_"+in.inputtype.toString
			BooleanStaticInput:	in.staticValue
			BooleanCarInput:	"in_"+in.inputtype.toString
			default :	if(in.predecessors.nullOrEmpty){
							"/*input not a reference*/"
						}else{
							IDHasher.GetStringHash(in.predecessors.head.id)
						}
		}	
	}
	
	def referenceOutput(Output out){
		switch out{
			NumberCarOutput :	"out_"+out.outputtype.toString
			BooleanCarOutput:	"out_"+out.outputtype.toString
			default :	IDHasher.GetStringHash(out.id)
		}	
	}
	
	def boolean importUtilityClass(Rule rule){
		return (rule.operations.filter(Minimum) + rule.operations.filter(Maximum)).length > 0
	}
}