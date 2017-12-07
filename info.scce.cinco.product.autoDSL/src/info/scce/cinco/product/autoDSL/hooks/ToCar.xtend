package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutput

class ToCar extends CincoCustomAction<IO> {

//TODO find generic but precise name (will be displayed in ContextMenu) 	
//	override getName() {}
	
	override execute(IO io) {
		val x = io.x as int
		val y = io.y as int
		val cont = LayoutManager.prepareConversion(io)
		switch io {
			BooleanInput : cont.newBooleanCarInput(x, y)
			BooleanOutput : cont.newBooleanCarOutput(x, y)
			NumberInput : cont.newNumberCarInput(x, y)
			NumberOutput : cont.newNumberCarOutput(x, y)
		}
	}
	
}