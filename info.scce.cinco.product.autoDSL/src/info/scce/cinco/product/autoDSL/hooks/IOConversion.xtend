package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.Addition
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanGuardOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.Decision
import info.scce.cinco.product.autoDSL.rule.rule.DirectBooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.DirectNumberOutput
import info.scce.cinco.product.autoDSL.rule.rule.Division
import info.scce.cinco.product.autoDSL.rule.rule.Equal
import info.scce.cinco.product.autoDSL.rule.rule.Greater
import info.scce.cinco.product.autoDSL.rule.rule.GreaterOrEqual
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.Less
import info.scce.cinco.product.autoDSL.rule.rule.LessOrEqual
import info.scce.cinco.product.autoDSL.rule.rule.LoadBoolean
import info.scce.cinco.product.autoDSL.rule.rule.LoadNumber
import info.scce.cinco.product.autoDSL.rule.rule.LogicalAnd
import info.scce.cinco.product.autoDSL.rule.rule.LogicalOr
import info.scce.cinco.product.autoDSL.rule.rule.Maximum
import info.scce.cinco.product.autoDSL.rule.rule.Minimum
import info.scce.cinco.product.autoDSL.rule.rule.Multiplication
import info.scce.cinco.product.autoDSL.rule.rule.Negation
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.NumberInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.rule.rule.PIDController
import info.scce.cinco.product.autoDSL.rule.rule.SaveBoolean
import info.scce.cinco.product.autoDSL.rule.rule.SaveNumber
import info.scce.cinco.product.autoDSL.rule.rule.StaticNumberValue
import info.scce.cinco.product.autoDSL.rule.rule.SubRule
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleInputs
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs
import info.scce.cinco.product.autoDSL.rule.rule.Subtraction

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

abstract class IOConversion extends CincoCustomAction<IO> {
	
	protected int x
	protected int y
	protected Operation op
	def memorize(IO io){
		x = io.x
		y = io.y
		op = io.operation
	}

	override getName() {
		"Covert to " + targetType
	}
	
	override execute(IO io) {
		LayoutManager.prepareConversion(io)
		io.createConversionTarget
	}
	
	override canExecute(IO io){
		io.memorize
		val root = io.rootElement
		val tmpOp = switch op {
			Addition : root.newAddition(0,0)
			BooleanGuardOutput : root.newBooleanGuardOutput(0,0)
			Decision : root.newDecision(0,0)
			DirectBooleanOutput : root.newDirectBooleanOutput(0,0)
			DirectNumberOutput : root.newDirectNumberOutput(0,0)
			Division : root.newDivision(0,0)
			Equal : root.newEqual(0,0)
			Greater : root.newGreater(0,0)
			GreaterOrEqual : root.newGreaterOrEqual(0,0)
			Less : root.newLess(0,0)
			LessOrEqual : root.newLessOrEqual(0,0)
			LoadBoolean : root.newLoadBoolean(null,0,0)
			LoadNumber : root.newLoadNumber(null,0,0)
			LogicalAnd : root.newLogicalAnd(0,0)
			LogicalOr : root.newLogicalOr(0,0)
			Maximum : root.newMaximum(0,0)
			Minimum : root.newMinimum(0,0)
			Multiplication : root.newMultiplication(0,0)
			Negation : root.newNegation(0,0)
			PIDController : root.newPIDController(0,0)
			SaveBoolean : root.newSaveBoolean(null,0,0)
			SaveNumber : root.newSaveNumber(null,0,0)
			SubRule : root.newSubRule(null,0,0)
			SubRuleInputs : root.newSubRuleInputs(0,0)
			SubRuleOutputs :root.newSubRuleOutputs(0,0)
			Subtraction : root.newSubtraction(0,0)
			StaticNumberValue : root.newStaticNumberValue(0,0)
		}
		for (input : tmpOp.inputs) input.delete
		for (output : tmpOp.outputs) output.delete
		for (input : op.inputs.filter[it != io]){
			switch input {
				BooleanCarInput : tmpOp.newBooleanCarInput(0,0)
				BooleanInputPort : tmpOp.newBooleanInputPort(0,0)
				BooleanStaticInput : tmpOp.newBooleanStaticInput(0,0)
				NumberCarInput : tmpOp.newNumberCarInput(0,0)
				NumberInputPort : tmpOp.newNumberInputPort(0,0)
				NumberStaticInput : tmpOp.newNumberStaticInput(0,0)
			}
		}
		for (output : op.outputs.filter[it != io]){
			switch output {
				BooleanCarOutput : tmpOp.newBooleanCarOutput(0,0)
				BooleanOutputPort : tmpOp.newBooleanInputPort(0,0)
				NumberCarOutput : tmpOp.newNumberCarOutput(0,0)
				NumberOutputPort : tmpOp.newNumberOutputPort(0,0)
			}
		}
		val p = io.canCreateConversionTarget(tmpOp)
		tmpOp.delete
		p
	}

	def String targetType()	
	def void createConversionTarget(IO io)
	def boolean canCreateConversionTarget(IO io, Operation op)
}