package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.*

class NumberPortToStatic extends CincoCustomAction<NumberInputPort> {
	
	override getName() {
		"Convert to: Static input"
	}
	
	override execute(NumberInputPort inp) {
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