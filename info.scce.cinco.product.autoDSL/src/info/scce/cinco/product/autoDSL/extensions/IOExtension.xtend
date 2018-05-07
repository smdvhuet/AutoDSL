package info.scce.cinco.product.autoDSL.extensions

import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class IOExtension {
	/**
	 * String used as identifier during deletion to avert alternating method calls causing a StackOverflow
	 * TODO: ensure this String won't/can't be chosen by the user
	 */
	public static val TEMPORARY_IDENTIFIER = "portDeletionInProgress"
	
	static def getOperation (IO io) {
		io.container as Operation
	}	
}