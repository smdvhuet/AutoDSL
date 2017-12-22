package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class ToStatic extends IOConversion {
	
	override getName() {
		getName("static")
	}
	
	override execute(IO io) {
		val x = io.x as int
		val y = io.y as int
		val op = io.operation
		LayoutManager.prepareConversion(io)
		switch io {
			BooleanInput : op.newBooleanStaticInput(x, y)
			NumberInput : op.newNumberStaticInput(x, y)
		}
	}
	
	override canExecute(IO io){
		switch io {
			BooleanInput : io.operation.canNewBooleanStaticInput
			NumberInput : io.operation.canNewNumberStaticInput
			default : super.canExecute(io)
		}
	}
	
}