package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.*

class NumberStaticToPort extends CincoCustomAction<NumberStaticInput> {
	
	override getName() {
		"Convert to: input port"
	}
	
	override execute(NumberStaticInput inp) {
		val x = inp.x as int
		val y = inp.y as int
		val cont = inp.container
		inp.delete
		if (cont instanceof CommutableOperation)
			(cont as CommutableOperation).newNumberInputPort(x, y)
		else
			(cont as NonCommutableOperation).newNumberInputPort(x, y)
	}
	
}