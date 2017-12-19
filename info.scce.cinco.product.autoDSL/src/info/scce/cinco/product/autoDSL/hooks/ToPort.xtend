package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutput

class ToPort extends IOConversion {
	
	override getName() {
		getName("port")
	}
	
	override execute(IO io) {
		val x = io.x as int
		val y = io.y as int
		val cont = LayoutManager.prepareConversion(io)
		switch io {
			BooleanInput : cont.newBooleanInputPort(x, y)
			BooleanOutput : cont.newBooleanOutputPort(x, y)
			NumberInput : cont.newNumberInputPort(x, y)
			NumberOutput : cont.newNumberOutputPort(x, y)
		}
	}
	
	override canExecute(IO io){
		val cont = LayoutManager.getOperation(io)
		switch io {
			BooleanInput : cont.canNewBooleanInputPort
			BooleanOutput : cont.canNewBooleanOutputPort
			NumberInput : cont.canNewNumberInputPort
			NumberOutput : cont.canNewNumberOutputPort
			default : super.canExecute(io)
		}
	}
	
}