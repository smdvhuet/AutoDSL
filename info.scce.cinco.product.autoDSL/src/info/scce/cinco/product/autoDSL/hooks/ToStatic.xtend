package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput

class ToStatic extends IOConversion {
	
	override getName() {
		getName("static")
	}
	
	override execute(IO io) {
		val x = io.x as int
		val y = io.y as int
		val cont = LayoutManager.prepareConversion(io)
		switch io {
			BooleanInput : cont.newBooleanStaticInput(x, y)
			NumberInput : cont.newNumberStaticInput(x, y)
		}
	}
	
}