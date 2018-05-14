package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class ToStatic extends IOConversion {
	
	override targetType() {
		"static"
	}
	
	override createConversionTarget(IO io) {
		switch io {
			BooleanInput case op.canNewBooleanStaticInput : op.newBooleanStaticInput(x, y)
			NumberInput case op.canNewNumberStaticInput : op.newNumberStaticInput(x, y)
		}
	}
	
	override canCreateConversionTarget(IO io, Operation op) {
		switch io {
			BooleanInput : op.canNewBooleanStaticInput
			NumberInput : op.canNewNumberStaticInput
			default : true
		}
	}
	
}