package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.*

class BooleanCarToStatic extends CincoCustomAction<BooleanCarInput> {
	
	override getName() {
		"Convert to: static input"
	}
	
	override execute(BooleanCarInput inp) {
		val x = inp.x as int
		val y = inp.y as int
		val cont = inp.container
		inp.delete
		if (cont instanceof CommutableOperation)
			(cont as CommutableOperation).newBooleanStaticInput(x, y)
		else
			(cont as NonCommutableOperation).newBooleanStaticInput(x, y)
	}
	
}