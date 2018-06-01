package info.scce.cinco.product.autoDSL.generator

import graphmodel.Node
import info.scce.cinco.product.autoDSL.rule.rule.Addition
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
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleInputs
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs
import info.scce.cinco.product.autoDSL.rule.rule.SubRule
import java.util.Iterator
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutputPort
import java.util.HashMap
import info.scce.cinco.product.autoDSL.rule.rule.Load
import info.scce.cinco.product.autoDSL.rule.rule.StoredPIDController
import info.scce.cinco.product.autoDSL.rule.rule.SaveNumber
import info.scce.cinco.product.autoDSL.rule.rule.SaveBoolean
import info.scce.cinco.product.autoDSL.rule.rule.LoadBoolean
import info.scce.cinco.product.autoDSL.rule.rule.LoadNumber
import info.scce.cinco.product.autoDSL.sharedMemory.sharedmemory.SharedMemory
import info.scce.cinco.product.autoDSL.rule.rule.Equal
import info.scce.cinco.product.autoDSL.rule.rule.Exponential
import info.scce.cinco.product.autoDSL.rule.rule.StaticNumberValue
import info.scce.cinco.product.autoDSL.rule.rule.StartNode
import info.scce.cinco.product.autoDSL.rule.rule.EndNode
import info.scce.cinco.product.autoDSL.rule.rule.ProgrammableNode
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubCarInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubCarInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberInputPort
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class NodeGenerator extends RuleSwitch<CharSequence> {
	
//*********************************************************************************
//								GENERATE ARITHMETICAL NODES
//*********************************************************************************
	
	//Addition
	override caseAddition(Addition it)'''
	//Addition Operator
	«outputs.head.referenceOutput» = «FOR input : inputs.sortBy[y] SEPARATOR '+'»«input.referenceInput»«ENDFOR»;
	«doLogging»
	«nextNode»
	'''
	
	//Division
	override caseDivision(Division it)'''
	//Division Operator
	«outputs.head.referenceOutput» = «inputs.sortBy[y].head.referenceInput» / «inputs.sortBy[y].last.referenceInput»;
	«doLogging»
	«nextNode»
	'''
	
	//Exponential
	override caseExponential(Exponential it)'''
	//Exponential Operator
	«outputs.head.referenceOutput» = pow(«inputs.sortBy[y].head.referenceInput», «inputs.sortBy[y].last.referenceInput»);
	«doLogging»
	«nextNode»
	'''
	
	//Maximum
	override caseMaximum(Maximum it)'''
	//Max Operator
	double «IDHasher.GetStringHash(id)»[] = {«FOR  input : inputs.sortBy[y] SEPARATOR ','»«input.referenceInput»«ENDFOR»};
	«outputs.head.referenceOutput» = ACCPlusPlus::Utility::max(«IDHasher.GetStringHash(id)»,«inputs.length»);
	«doLogging»
	«nextNode»
	'''
	
	//Minimum
	override caseMinimum(Minimum it)'''
	//Min Operator
	double «IDHasher.GetStringHash(id)»[] = {«FOR  input : inputs.sortBy[y] SEPARATOR ','»«input.referenceInput»«ENDFOR»};
	«outputs.head.referenceOutput» = ACCPlusPlus::Utility::min(«IDHasher.GetStringHash(id)»,«inputs.length»);
	«doLogging»
	«nextNode»
	'''
	
	//Multiplication
	override caseMultiplication(Multiplication it)'''
	//Multiplication Operator
	«outputs.head.referenceOutput» = «FOR input : inputs.sortBy[y] SEPARATOR '*'»«input.referenceInput»«ENDFOR»;
	«doLogging»
	«nextNode»
	'''
	
	//Substraction
	override caseSubtraction(Subtraction it)'''
	//Substraction Operator
	«outputs.head.referenceOutput» = «inputs.sortBy[y].head.referenceInput» - «inputs.sortBy[y].last.referenceInput»;
	«doLogging»
	«nextNode»
	'''
	


//*********************************************************************************
//								GENERATE SUBRULEPORTS
//*********************************************************************************

	//BooleanSubInput
	 override caseBooleanSubInputPort (BooleanSubInputPort it){
	 	if(predecessors.nullOrEmpty){
			"/*input not a reference*/"
		}else{
			val out = predecessors.head
			if(out instanceof Output){
				out.referenceOutputFromInput
			}else{
				"/*input is a reference for something thats not an output*/"
			}
		}
	 }
	 
	 //BooleanSubCarInput
	 override caseBooleanSubCarInput(BooleanSubCarInput it){
	 	"input."+inputtype.toString
	 }
	 
	 //BooleanSubOutput
	 override caseBooleanSubOutputPort(BooleanSubOutputPort it){
	 	if(container instanceof SubRule){
			IDHasher.GetStringHash(id)
		}else{
			NamingUtilities.toMemberVar(identifier)
		}
	 }
	 
	 //BooleanSubStaticInput
	 override caseBooleanSubStaticInput(BooleanSubStaticInput it){
	 	staticValue.toString
	 }
	 
	 //NumberSubInput
	 override caseNumberSubInputPort(NumberSubInputPort it){
	 	if(predecessors.nullOrEmpty){
			"/*input not a reference*/"
		}else{
			val out = predecessors.head
			if(out instanceof Output){
				out.referenceOutputFromInput
			}else{
				"/*input is a reference for something thats not an output*/"
			}
		}
	 }
	 
	 //NumberSubCarInput
	 override caseNumberSubCarInput(NumberSubCarInput it){
	 	"input."+inputtype.toString
	 }
	 
	 //NumberSubOutput
	 override caseNumberSubOutputPort(NumberSubOutputPort it){
	 	if(container instanceof SubRule){
			IDHasher.GetStringHash(id)
		}else{
			NamingUtilities.toMemberVar(identifier)
		}
	 }
	 
	 //NumberSubStaticInput
	 override caseNumberSubStaticInput(NumberSubStaticInput it){
	 	staticValue.toString
	 }
	 
//*********************************************************************************
//								GENERATE PORTS
//*********************************************************************************
	 
	 //BooleanCarInput
	 override caseBooleanCarInput(BooleanCarInput it){
	 	"input."+inputtype.toString
	 }
	 
	 //BooleanCarOut
	 override caseBooleanCarOutput(BooleanCarOutput it){
	 	"output."+outputtype.toString
	 }

	//BooleanInput
	 override caseBooleanInputPort (BooleanInputPort it){
	 	if(predecessors.nullOrEmpty){
			"/*input not a reference*/"
		}else{
			val out = predecessors.head
			if(out instanceof Output){
				out.referenceOutputFromInput
			}else{
				"/*input is a reference for something thats not an output*/"
			}
		}
	 }
	 
	 //BooleanStaticInput
	 override caseBooleanStaticInput(BooleanStaticInput it){
	 	staticValue.toString
	 }
	 
	 //NumberCarInput
	 override caseNumberCarInput(NumberCarInput it){
	 	"input."+inputtype.toString
	 }
	 
	 //NumberCarOutput
	 override caseNumberCarOutput(NumberCarOutput it){
	 	"output."+outputtype.toString
	 }
	 
	 //NumberInput
	 override caseNumberInputPort(NumberInputPort it){
	 	if(predecessors.nullOrEmpty){
			"/*input not a reference*/"
		}else{
			val out = predecessors.head
			if(out instanceof Output){
				out.referenceOutputFromInput
			}else{
				"/*input is a reference for something thats not an output*/"
			}
		}
	 }
	 
	 //NumberStaticInput
	 override caseNumberStaticInput(NumberStaticInput it){
	 	staticValue.toString
	 }

//*********************************************************************************
//								GENERATE DIRECT IO NODES
//*********************************************************************************

	//DirectBooleanOutput
	override caseDirectBooleanOutput(DirectBooleanOutput it)'''
	//Boolean Output
	«booleanCarOutputs.head.referenceOutput» = «booleanInputs.head.referenceInput»;
	«doLogging»
	«nextNode»
	'''

	//DirectNumberOutput
	override caseDirectNumberOutput(DirectNumberOutput it)'''
	//Number Output
	«numberCarOutputs.head.referenceOutput» = «numberInputs.head.referenceInput»;
	«doLogging»
	«nextNode»
	'''
	
//*********************************************************************************
//								GENERATE LOGICAL NODES
//*********************************************************************************

	//Decision
	override caseDecision(Decision it)'''
	if(«booleanInputs.head.referenceInput»){
		«doLogging»
		«outgoing.filter(ControlFlowDecisionTrue).head.getTargetElement.doSwitch»
	}«IF !outgoing.filter(ControlFlowDecisionFalse).nullOrEmpty» else{
		«doLogging»
		«outgoing.filter(ControlFlowDecisionFalse).head.getTargetElement.doSwitch»
	}«ENDIF»
	'''
	
	//Equal
	override caseEqual(Equal it)'''
	//Equal Operator
	«outputs.head.referenceOutput» = «inputs.sortBy[y].head.referenceInput» == «inputs.sortBy[y].last.referenceInput»;
	«doLogging»
	«nextNode»
	'''
	
	//Less
	override caseLess(Less it)'''
	//Less Operator
	«outputs.head.referenceOutput» = «inputs.sortBy[y].head.referenceInput» < «inputs.sortBy[y].last.referenceInput»;
	«doLogging»
	«nextNode»
	'''
	
	//Greater
	override caseGreater(Greater it)'''
	//Greater Operator
	«outputs.head.referenceOutput» = «inputs.sortBy[y].head.referenceInput» > «inputs.sortBy[y].last.referenceInput»;
	«doLogging»
	«nextNode»
	'''
	
	//GreaterOrEqual
	override caseGreaterOrEqual(GreaterOrEqual it)'''
	//GreaterOrEqual Operator
	«outputs.head.referenceOutput» = «inputs.sortBy[y].head.referenceInput» >= «inputs.sortBy[y].last.referenceInput»;
	«doLogging»
	«nextNode»
	'''
	
	//LessOrEqual
	override caseLessOrEqual(LessOrEqual it)'''
	//LessOrEqual Operator
	«outputs.head.referenceOutput» = «inputs.sortBy[y].head.referenceInput» <= «inputs.sortBy[y].last.referenceInput»;
	«doLogging»
	«nextNode»
	'''
	
	//And
	override caseLogicalAnd(LogicalAnd it)'''
	//And Operator
	«outputs.head.referenceOutput» = «FOR in : inputs.sortBy[y] SEPARATOR '&&'»«in.referenceInput»«ENDFOR»;
	«doLogging»
	«nextNode»
	'''
	
	//Or
	override caseLogicalOr(LogicalOr it)'''
	//Or Operator
	«outputs.head.referenceOutput» = «FOR in : inputs.sortBy[y] SEPARATOR '||'»«in.referenceInput»«ENDFOR»;
	«doLogging»
	«nextNode»
	'''

	//Negation
	override caseNegation(Negation it)'''
	//Negation Operator
	«booleanOutputs.head.referenceOutput» = !«booleanInputs.head.referenceInput»;
	«doLogging»
	«nextNode»
	'''

//*********************************************************************************
//								GENERATE OTHER NODES
//*********************************************************************************
	
	//GuardOutput
	override caseBooleanGuardOutput(BooleanGuardOutput it)'''
	//Guard Output
	return «booleanInputs.head.referenceInput»;
	«doLogging»
	«nextNode»
	'''
	
	//EndNode
	override caseEndNode(EndNode node)'''
	//END
	'''
	
	//PID
	override casePIDController(PIDController it)'''
	//PID Controller
	«outputs.head.referenceOutput» = pid«IDHasher.GetStringHash(id)».calculate(«inputs.sortBy[y].head.referenceInput», «inputs.sortBy[y].last.referenceInput», input.dTime);	
	«doLogging»
	«nextNode»
	'''
	
	//TODO:ProgrammableNode
	override caseProgrammableNode(ProgrammableNode it)'''
	//ProgrammableNode
	«code»
	«doLogging»
	«nextNode»
	'''
	
	//StartNode
	override caseStartNode(StartNode it)'''
	«nextNode»
	'''
	
	//StaticNumber
	override caseStaticNumberValue(StaticNumberValue it)'''
	«outputs.head.referenceOutput» = «inputs.head.referenceInput»;
	«doLogging»
	«nextNode»
	'''

//*********************************************************************************
//								GENERATE SUBRULE IO NODES
//*********************************************************************************
	
	//SubRuleInputs
	override caseSubRuleInputs(SubRuleInputs it)'''
	«doLogging»
	«nextNode»
	'''
	
	//SubRuleOutputs
	override caseSubRuleOutputs(SubRuleOutputs it)'''
	//SubRule Outputs
	«FOR BooleanSubInputPort port:booleanSubInputPorts»
		«NamingUtilities.toMemberVar(port.identifier)» = «port.referenceInput»;
		ACC_LOG2("Subrule output '«NamingUtilities.toMemberVar(port.identifier)»' is set to'" << «port.referenceInput» << "'.")
	«ENDFOR»
	«FOR NumberSubInputPort port:numberSubInputPorts»
		«NamingUtilities.toMemberVar(port.identifier)» = «port.referenceInput»;
		ACC_LOG2("Subrule output '«NamingUtilities.toMemberVar(port.identifier)»' is set to'" << «port.referenceInput» << "'.")
	«ENDFOR»
	«doLogging»
	«nextNode»
	'''

//*********************************************************************************
//								GENERATE SUBRULES
//*********************************************************************************
	
	override caseSubRule(SubRule it)'''
	«IF !booleanSubInputPorts.nullOrEmpty»//BooleanSubInputs
	«val Iterator<BooleanSubOutputPort> refBoolIns = rule.subRuleInputss.head.booleanSubOutputPorts.iterator»
	«FOR in:booleanSubInputPorts»
		«IDHasher.GetStringHash(id)».«refBoolIns.next.referenceOutput» = «in.referenceInput»;
	«ENDFOR»
	
	«ENDIF»
	«IF !numberSubInputPorts.nullOrEmpty»//NumberSubInputs
	«val Iterator<NumberSubOutputPort> refNumberIns = rule.subRuleInputss.head.numberSubOutputPorts.iterator»
	«FOR in:numberSubInputPorts»
		«IDHasher.GetStringHash(id)».«refNumberIns.next.referenceOutput» = «in.referenceInput»;
	«ENDFOR»
	
	«ENDIF»
	// SubRule execution
	«IF RuleGenerator.isStateRule(rule)»
		«IDHasher.GetStringHash(id)».Execute(input, output);
	«ELSEIF RuleGenerator.isGuardRule(rule)»
		return «IDHasher.GetStringHash(rule.id)».Execute(input);
	«ELSEIF RuleGenerator.isNeutralRule(rule)»
		«IDHasher.GetStringHash(id)».Execute(input);
	«ELSE»
		//SubRule is not StateRule, GuardRule or NeutralRule
	«ENDIF»
	
	«IF !booleanSubOutputPorts.nullOrEmpty»//BooleanSubOutputs
	«val Iterator<BooleanSubInputPort> refBoolOuts = rule.subRuleOutputss.head.booleanSubInputPorts.iterator»
	«FOR out:booleanSubOutputPorts»
		bool «out.referenceOutput» = «IDHasher.GetStringHash(id)».«NamingUtilities.toMemberVar(refBoolOuts.next.identifier)»;
	«ENDFOR»
	
	«ENDIF»
	«IF !numberSubOutputPorts.nullOrEmpty»//NumberSubOutputs
	«val Iterator<NumberSubInputPort> refNumberOuts = rule.subRuleOutputss.head.numberSubInputPorts.iterator»
	«FOR out:numberSubOutputPorts»
		double «out.referenceOutput» = «IDHasher.GetStringHash(id)».«NamingUtilities.toMemberVar(refNumberOuts.next.identifier)»;
	«ENDFOR»
	
	«ENDIF»
	«doLogging»
	«nextNode»
	'''

//*********************************************************************************
//								GENERATE SHARED MEMORY NODES
//*********************************************************************************
	
	//SaveNumber
	override caseSaveNumber(SaveNumber it)'''
	//Saving Data
	«data.rootElement.memoryName».«data.label» = «inputs.head.referenceInput»;
	ACC_LOG2("Sharedmemory '«data.rootElement.memoryName».«data.label»' is set to'" << «inputs.head.referenceInput» << "'.")
	«doLogging»
	«nextNode»
	'''
	
	//SaveBoolean
	override caseSaveBoolean(SaveBoolean it)'''
	//Saving Data
	«data.rootElement.memoryName».«data.label» = «inputs.head.referenceInput»;
	ACC_LOG2("Sharedmemory '«data.rootElement.memoryName».«data.label»' is set to'" << «inputs.head.referenceInput» << "'.")
	«doLogging»
	«nextNode»
	'''
	
	//Load
	override caseLoad(Load it)'''
	«doLogging»
	«nextNode»
	'''
	
	//StoredPID
	override caseStoredPIDController(StoredPIDController it)'''
	//Stored PID
	«outputs.head.referenceOutput» = «data.rootElement.memoryName».«data.label».calculate(«inputs.sortBy[y].head.referenceInput», «inputs.sortBy[y].last.referenceInput», input.dTime);
	«doLogging»
	«nextNode»
	'''
	

//*********************************************************************************
//								GENERATE DEFAULT
//*********************************************************************************

	
	override caseNode(Node it)'''/*Node «toString» not found*/
	«nextNode»
	'''

//*********************************************************************************
//								FUNCTIONS REFERENCE IO
//*********************************************************************************

	def referenceInput(Input it){
		doSwitch
	}
	
	def referenceOutputFromInput(Output it){
		switch it{
			NumberOutputPort:	if(container instanceof LoadNumber){
									(container as LoadNumber).data.rootElement.memoryName+"."+(container as LoadNumber).data.label
								}else{
									IDHasher.GetStringHash(id)
								}
			BooleanOutputPort:	if(container instanceof LoadBoolean){
									(container as LoadBoolean).data.rootElement.memoryName+"."+(container as LoadBoolean).data.label
								}else{
									IDHasher.GetStringHash(id)
								}
			default:			doSwitch
		}	
	}
	
	def referenceOutput(Output it){
		switch it{
			NumberOutputPort:	if(container instanceof LoadNumber){
									(container as LoadNumber).data.rootElement.memoryName+"."+(container as LoadNumber).data.label
								}else{
									"double "+IDHasher.GetStringHash(id)
									}
			BooleanOutputPort:	if(container instanceof LoadBoolean){
									(container as LoadBoolean).data.rootElement.memoryName+"."+(container as LoadBoolean).data.label
								}else{
									"bool "+IDHasher.GetStringHash(id)
								}
			default:			doSwitch
		}	
	}

//*********************************************************************************
//								FUNCTIONS FOR LOGGING
//*********************************************************************************
	
	def doLogging(Operation it)'''
	«FOR in:inputs»
		«IF !in.loggingIdentifier.nullOrEmpty»
			«in.logInput»
		«ENDIF»
	«ENDFOR»
	«FOR out:outputs»
			«IF !out.loggingIdentifier.nullOrEmpty»
				«out.logOutput»
			«ENDIF»
		«ENDFOR»
	'''
	
	//TODO
	def logInput(Input it){
	}
	
	//TODO
	def logOutput(Output it){
	}

//*********************************************************************************
//								OTHER FUNCTIONS
//*********************************************************************************
	
	public def generateSubRulePorts(Rule mainRule)'''
	«var HashMap<Integer, Rule> knownSubRules = new HashMap<Integer, Rule>()»
	«FOR rule:mainRule.subRules»
		«IF !knownSubRules.containsValue(rule.rule)»
			«knownSubRules.put(IDHasher.GetIntHash(rule.rule.id),rule.rule)»
			«IF !rule.booleanSubInputPorts.nullOrEmpty && !rule.numberSubInputPorts.nullOrEmpty && !rule.booleanSubOutputPorts.nullOrEmpty && !rule.numberSubOutputPorts.nullOrEmpty»//subRule «IDHasher.GetIntHash(rule.rule.id)»«ENDIF»
			«IF !rule.booleanSubInputPorts.nullOrEmpty»//BooleanSubInputs
			«val Iterator<BooleanSubOutputPort> refBoolIns = rule.rule.subRuleInputss.head.booleanSubOutputPorts.iterator»
			«FOR BooleanSubInputPort in:rule.booleanSubInputPorts»
				bool «refBoolIns.next.referenceOutput»;
			«ENDFOR»
			
			«ENDIF»
			«IF !rule.numberSubInputPorts.nullOrEmpty»//NumberSubInputs
			«val Iterator<NumberSubOutputPort> refNumberIns = rule.rule.subRuleInputss.head.numberSubOutputPorts.iterator»
			«FOR NumberSubInputPort in:rule.numberSubInputPorts»
				double «refNumberIns.next.referenceOutput»;
			«ENDFOR»
			
			«ENDIF»
			«IF !rule.booleanSubOutputPorts.nullOrEmpty»//BooleanSubOutputs
			«FOR BooleanSubInputPort out:rule.rule.subRuleOutputss.head.booleanSubInputPorts»
				bool «IDHasher.GetStringHash(rule.rule.id)+"_"+NamingUtilities.toMemberVar(out.identifier)»;
			«ENDFOR»
			
			«ENDIF»
			«IF !rule.numberSubOutputPorts.nullOrEmpty»//NumberSubOutputs
			«FOR NumberSubInputPort out:rule.rule.subRuleOutputss.head.numberSubInputPorts»
				double «IDHasher.GetStringHash(rule.rule.id)+"_"+NamingUtilities.toMemberVar(out.identifier)»;
			«ENDFOR»
			
			«ENDIF»
		«ENDIF»
	«ENDFOR»
	'''
	
	def getMemoryName(SharedMemory memory){
		return "g"+SharedMemoryGenerator.getMemoryName(memory)+"_var";
	}
	
	def nextNode(Node it){
		if(!getSuccessors.nullOrEmpty){
			return getSuccessors.head.doSwitch
		}
	}
}