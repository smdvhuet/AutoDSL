package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.IO

abstract class IOConversion extends CincoCustomAction<IO> {

	def getName(String str) {
		"Covert to " + str
	}
	
}