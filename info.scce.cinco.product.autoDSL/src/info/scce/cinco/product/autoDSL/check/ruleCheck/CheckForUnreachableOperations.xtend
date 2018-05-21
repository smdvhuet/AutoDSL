package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Addition
import info.scce.cinco.product.autoDSL.rule.rule.BooleanInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.ControlFlowDecisionFalse
import info.scce.cinco.product.autoDSL.rule.rule.ControlFlowDecisionTrue
import info.scce.cinco.product.autoDSL.rule.rule.Division
import info.scce.cinco.product.autoDSL.rule.rule.Greater
import info.scce.cinco.product.autoDSL.rule.rule.GreaterOrEqual
import info.scce.cinco.product.autoDSL.rule.rule.Input
import info.scce.cinco.product.autoDSL.rule.rule.Less
import info.scce.cinco.product.autoDSL.rule.rule.LessOrEqual
import info.scce.cinco.product.autoDSL.rule.rule.LogicalAnd
import info.scce.cinco.product.autoDSL.rule.rule.LogicalOr
import info.scce.cinco.product.autoDSL.rule.rule.Maximum
import info.scce.cinco.product.autoDSL.rule.rule.Minimum
import info.scce.cinco.product.autoDSL.rule.rule.Multiplication
import info.scce.cinco.product.autoDSL.rule.rule.Negation
import info.scce.cinco.product.autoDSL.rule.rule.NumberInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.Subtraction
import java.util.ArrayList
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarInput

class CheckForUnreachableOperations extends RuleCheck{
	
	enum BooleanOrDynamic {
		TRUE,
		FALSE,
		DYNAMIC
	}
	
	override check(Rule rule) {
		for(decision : rule.decisions){
			val decisionInput = decision.inputs.head
			var BooleanOrDynamic decisionTrue
			if(!decisionInput.incoming.isEmpty){
				switch decisionInput{
					BooleanInputPort : decisionTrue = decisionInput.origin.staticBooleanValue
					BooleanStaticInput : decisionTrue = decisionInput.staticValue.booleanValue.toBooleanOrDynamic
				}
			}
			for(outgoing : decision.outgoing){
				switch outgoing {
					ControlFlowDecisionFalse : switch decisionTrue { case TRUE : outgoing.addWarning("Operation unreachable/Decision is static") }
					ControlFlowDecisionTrue : switch decisionTrue { case FALSE : outgoing.addWarning("Operation unreachable/Decision is static") }
				}
			}
		}
	}
	
	def origin(Input input) {
		input.incoming.head.sourceElement.container as Operation
	}
	
	def BooleanOrDynamic staticBooleanValue(Operation op) {
		var outputValue = BooleanOrDynamic.DYNAMIC
		var ArrayList<BooleanOrDynamic> inputValues = newArrayList
		var ArrayList<Pair<Integer,Float>> numberInputValues = newArrayList
		for(input : op.inputs){
			switch input {
				BooleanCarInput : inputValues.add(BooleanOrDynamic.DYNAMIC)
				BooleanInputPort : inputValues.add(input.origin.staticBooleanValue)
				BooleanStaticInput : inputValues.add(input.staticValue.booleanValue.toBooleanOrDynamic)
				NumberCarInput : numberInputValues.add(input.y->null)
				NumberInputPort : numberInputValues.add(input.y->input.origin.staticNumberValue)
				NumberStaticInput : numberInputValues.add(input.y->input.staticValue.floatValue)
			}
		}
		if(!numberInputValues.map[value].contains(null)){
			switch op {
				Greater : outputValue = (numberInputValues.sortBy[key].head.value > numberInputValues.sortBy[key].last.value).toBooleanOrDynamic
				GreaterOrEqual : outputValue = (numberInputValues.sortBy[key].head.value >= numberInputValues.sortBy[key].last.value).toBooleanOrDynamic
				Less : outputValue = (numberInputValues.sortBy[key].head.value < numberInputValues.sortBy[key].last.value).toBooleanOrDynamic
				LessOrEqual : outputValue = (numberInputValues.sortBy[key].head.value <= numberInputValues.sortBy[key].last.value).toBooleanOrDynamic
				LogicalAnd : {
					outputValue = BooleanOrDynamic.TRUE
					for( inputValue: inputValues ) outputValue = outputValue && inputValue
				}
				LogicalOr : for( inputValue: inputValues ) outputValue = !(!outputValue && !inputValue)
				Negation : outputValue = !inputValues.head
			}
		}
		outputValue
	}
	
	def Float staticNumberValue(Operation op) {
		var Float outputValue = null
		var ArrayList<Pair<Integer,Float>> inputValues = newArrayList
		for(input : op.inputs){
			switch input {
				NumberInputPort : inputValues.add(input.y->input.origin.staticNumberValue)
				NumberStaticInput : inputValues.add(input.y->input.staticValue.floatValue)
			}
		}
		if(!inputValues.map[value].contains(null)) {
			switch op {
				Addition : {
					outputValue = 0f
					for( i : inputValues ) outputValue = outputValue + i.value
				}
				Division : outputValue = inputValues.sortBy[key].head.value / inputValues.sortBy[key].last.value
				Maximum : outputValue = inputValues.map[value].max
				Minimum : outputValue = inputValues.map[value].min
				Multiplication : {
					outputValue = 1f
					for( i : inputValues ) outputValue = outputValue * i.value
				}
				Subtraction : outputValue = inputValues.sortBy[key].head.value - inputValues.sortBy[key].last.value
			}
		}
		outputValue
	}
	
	def BooleanOrDynamic ! (BooleanOrDynamic b) {
		switch b {
			case TRUE : BooleanOrDynamic.FALSE
			case FALSE : BooleanOrDynamic.TRUE
			case DYNAMIC : BooleanOrDynamic.DYNAMIC 
		}
	}
	
	def BooleanOrDynamic && (BooleanOrDynamic a, BooleanOrDynamic b) {
		if ( ( a == BooleanOrDynamic.TRUE ) && ( b == BooleanOrDynamic.TRUE ) ) BooleanOrDynamic.TRUE
		else if ( ( a == BooleanOrDynamic.FALSE ) || ( b == BooleanOrDynamic.FALSE ) ) BooleanOrDynamic.FALSE
		else BooleanOrDynamic.DYNAMIC
	}
	
	def BooleanOrDynamic toBooleanOrDynamic (boolean b) {
		if (b) BooleanOrDynamic.TRUE
		else BooleanOrDynamic.FALSE
	}
}