package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput

class ToStatic extends IOConversion {
	
	override targetType() {
		"static"
	}
	
	override createConversionTarget(IO io) {
		switch io {
			BooleanSubInput case op.canNewBooleanSubStaticInput : op.newBooleanSubStaticInput(x, y)
			BooleanInput case op.canNewBooleanStaticInput : op.newBooleanStaticInput(x, y)
			NumberSubInput case op.canNewNumberSubStaticInput : op.newNumberSubStaticInput(x, y)
			NumberInput case op.canNewNumberStaticInput : op.newNumberStaticInput(x, y)
		}
	}
	
	override canCreateConversionTarget(IO io, Operation op) {
		switch io {
//			BooleanSubInput : op.canNewBooleanSubStaticInput
			BooleanInput : op.canNewBooleanStaticInput
			NumberSubInput : op.canNewNumberSubStaticInput
			NumberInput : op.canNewNumberStaticInput
			default : true
		}
	}
}