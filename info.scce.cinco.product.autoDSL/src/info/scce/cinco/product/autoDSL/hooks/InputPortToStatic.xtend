package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.tmprule.tmprule.*

class InputPortToStatic extends CincoCustomAction<InputPort> {
	
	override getName() {
		"Input to Static"
	}
	
	override execute(InputPort inp) {
		val x = inp.x as int
		val y = inp.y as int
		val cont = inp.container
		inp.delete
		if (cont instanceof CommutableOperation)
			(cont as CommutableOperation).newNumberStaticInput(x, y)
		else
			(cont as NonCommutableOperation).newNumberStaticInput(x, y)
	}
	
}