package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.*

class BooleanPortToStatic extends CincoCustomAction<BooleanInputPort> {
	
	override getName() {
		"Convert to: static input"
	}
	
	override execute(BooleanInputPort inp) {
		val x = inp.x as int
		val y = inp.y as int
		val cont = inp.container
		inp.delete
		if (cont instanceof Operation)
			(cont as Operation).newBooleanStaticInput(x, y)
	}
	
}