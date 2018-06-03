package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanProgrammableNodeInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberProgrammableNodeInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class ToStatic extends IOConversion {
	
	override targetType() {
		"static"
	}
	
	override createConversionTarget(IO io) {
		switch io {
			BooleanProgrammableNodeInput case op.canNewBooleanProgrammableNodeStaticInput : op.newBooleanProgrammableNodeStaticInput(x, y).identifier = programmableNodeID
			BooleanSubInput case op.canNewBooleanSubStaticInput : op.newBooleanSubStaticInput(x, y)
			BooleanInput case op.canNewBooleanStaticInput : op.newBooleanStaticInput(x, y)
			NumberProgrammableNodeInput case op.canNewNumberProgrammableNodeStaticInput : op.newNumberProgrammableNodeStaticInput(x, y).identifier = programmableNodeID
			NumberSubInput case op.canNewNumberSubStaticInput : op.newNumberSubStaticInput(x, y)
			NumberInput case op.canNewNumberStaticInput : op.newNumberStaticInput(x, y)
		}
	}
	
	override canCreateConversionTarget(IO io, Operation op) {
		switch io {
			BooleanProgrammableNodeInput : op.canNewBooleanProgrammableNodeStaticInput
			BooleanSubInput : op.canNewBooleanSubStaticInput
			BooleanInput : op.canNewBooleanStaticInput
			NumberProgrammableNodeInput : op.canNewNumberProgrammableNodeStaticInput
			NumberSubInput : op.canNewNumberSubStaticInput
			NumberInput : op.canNewNumberStaticInput
			default : true
		}
	}
}