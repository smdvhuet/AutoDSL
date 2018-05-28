package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutput
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput

class ToPort extends IOConversion {
	
	override targetType() {
		"port"
	}
	
	override createConversionTarget(IO io) {
		switch io {
			BooleanSubInput case op.canNewBooleanSubInputPort : op.newBooleanSubInputPort(x, y)
			BooleanInput case op.canNewBooleanInputPort : op.newBooleanInputPort(x, y)
			BooleanOutput case op.canNewBooleanOutputPort : op.newBooleanOutputPort(x, y)
			NumberSubInput case op.canNewNumberSubInputPort : op.newNumberSubInputPort(x, y)
			NumberInput case op.canNewNumberInputPort : op.newNumberInputPort(x, y)
			NumberOutput case op.canNewNumberOutputPort : op.newNumberOutputPort(x, y)
		}
	}
	
	override canCreateConversionTarget(IO io, Operation op) {
		switch io {
			BooleanSubInput : op.canNewBooleanSubInputPort
			BooleanInput : op.canNewBooleanInputPort
			BooleanOutput : op.canNewBooleanOutputPort
			NumberSubInput : op.canNewNumberSubInputPort
			NumberInput : op.canNewNumberInputPort
			NumberOutput : op.canNewNumberOutputPort
			default : true
		}
	}
	
}