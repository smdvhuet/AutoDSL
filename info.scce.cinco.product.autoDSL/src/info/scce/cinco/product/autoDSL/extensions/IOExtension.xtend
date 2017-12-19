package info.scce.cinco.product.autoDSL.extensions

import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class IOExtension {
	static def getOperation (IO io) {
		io.container as Operation
	}	
}