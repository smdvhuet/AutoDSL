package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutput
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput

class ToCar extends IOConversion {

//TODO find generic but precise name (will be displayed in ContextMenu) and adjust counterparts for static and port to match.
	override targetType() {
		"car"
	}
	
	override createConversionTarget(IO io) {
		switch io {
			BooleanSubInput case op.canNewBooleanSubCarInput : op.newBooleanSubCarInput(x, y)
			BooleanInput case op.canNewBooleanCarInput : op.newBooleanCarInput(x, y)
			BooleanOutput case op.canNewBooleanCarOutput  : op.newBooleanCarOutput(x, y)
			NumberSubInput case op.canNewNumberSubCarInput : op.newNumberSubCarInput(x, y)
			NumberInput case op.canNewNumberCarInput : op.newNumberCarInput(x, y)
			NumberOutput case op.canNewNumberCarOutput : op.newNumberCarOutput(x, y)
		}
	}
	
	override canCreateConversionTarget(IO io, Operation op) {
		switch io {
			BooleanSubInput : op.canNewBooleanSubCarInput
			BooleanInput : op.canNewBooleanCarInput
			BooleanOutput : op.canNewBooleanCarOutput
			NumberSubInput : op.canNewNumberSubCarInput
			NumberInput : op.canNewNumberCarInput
			NumberOutput : op.canNewNumberCarOutput
			default : true
		}
	}
	
}