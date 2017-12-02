package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class ToStatic extends CincoCustomAction<IO> {
	
	override execute(IO io) {
		val x = io.x as int
		val y = io.y as int
		val cont = io.container as Operation
		io.delete
		switch io {
			BooleanInput : cont.newBooleanStaticInput(x, y)
			NumberInput : cont.newNumberStaticInput(x, y)
		}
	}
	
}