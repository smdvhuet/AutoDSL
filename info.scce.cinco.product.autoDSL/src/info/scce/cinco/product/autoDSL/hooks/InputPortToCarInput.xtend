package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.tmprule.tmprule.*

class InputPortToCarInput extends CincoCustomAction<InputPort> {
	
	override getName() {
		"Convert to: Car input"
	}
	
	override execute(InputPort inp) {
		val x = inp.x as int
		val y = inp.y as int
		val cont = inp.container
		val type = inp.datatype
		inp.delete
		if (cont instanceof CommutableOperation)
			(cont as CommutableOperation).newCarInput(x, y).setDatatype(type)
		else
			(cont as NonCommutableOperation).newCarInput(x, y).setDatatype(type)
	}
	
}