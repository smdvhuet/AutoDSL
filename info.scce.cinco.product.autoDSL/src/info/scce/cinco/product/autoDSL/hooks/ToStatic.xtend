package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput

class ToStatic extends CincoCustomAction<IO> {
	
//TODO find generic but precise name (will be displayed in ContextMenu) 	
//	override getName() {}
	
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