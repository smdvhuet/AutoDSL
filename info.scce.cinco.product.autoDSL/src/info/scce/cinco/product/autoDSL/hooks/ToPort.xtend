package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutput

class ToPort extends IOConversion {
	
	override targetType() {
		"port"
	}
	
	override createConversionTarget(IO io) {
		switch io {
			BooleanInput case op.canNewBooleanInputPort : op.newBooleanInputPort(x, y)
			BooleanOutput case op.canNewBooleanOutputPort : op.newBooleanOutputPort(x, y)
			NumberInput case op.canNewNumberInputPort : op.newNumberInputPort(x, y)
			NumberOutput case op.canNewNumberOutputPort : op.newNumberOutputPort(x, y)
		}
	}
	
	override canCreateConversionTarget(IO io) {
		switch io {
			BooleanInput : op.canNewBooleanInputPort
			BooleanOutput : op.canNewBooleanOutputPort
			NumberInput : op.canNewNumberInputPort
			NumberOutput : op.canNewNumberOutputPort
			default : true
		}
	}
	
}