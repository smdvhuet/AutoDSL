package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutput
import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class ToPort extends IOConversion {
	
	override getName() {
		getName("port")
	}
	
	override execute(IO io) {
		val x = io.x as int
		val y = io.y as int
		LayoutManager.prepareConversion(io)
		switch io {
			BooleanInput : io.operation.newBooleanInputPort(x, y)
			BooleanOutput : io.operation.newBooleanOutputPort(x, y)
			NumberInput : io.operation.newNumberInputPort(x, y)
			NumberOutput : io.operation.newNumberOutputPort(x, y)
		}
	}
	
	override canExecute(IO io){
		switch io {
			BooleanInput : io.operation.canNewBooleanInputPort
			BooleanOutput : io.operation.canNewBooleanOutputPort
			NumberInput : io.operation.canNewNumberInputPort
			NumberOutput : io.operation.canNewNumberOutputPort
			default : super.canExecute(io)
		}
	}
	
}