package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.*

class NumberCarToStatic extends CincoCustomAction<NumberCarInput> {
	
	override getName() {
		"Convert to: static input"
	}
	
	override execute(NumberCarInput inp) {
		val x = inp.x as int
		val y = inp.y as int
		val cont = inp.container
		inp.delete
		if (cont instanceof Operation)
			(cont as Operation).newNumberStaticInput(x, y)
	}
	
}