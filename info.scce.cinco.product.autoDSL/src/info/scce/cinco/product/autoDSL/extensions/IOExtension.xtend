package info.scce.cinco.product.autoDSL.extensions

import info.scce.cinco.product.autoDSL.rule.rule.BooleanInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubCarInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubCarInput

class IOExtension {
	/**
	 * String used as identifier during deletion to avert alternating method calls causing a StackOverflow
	 * TODO: ensure this String won't/can't be chosen by the user
	 */
	public static val TEMPORARY_IDENTIFIER = "portDeletionInProgress"
	
	static def getOperation (IO io) {
		io.container as Operation
	}
	
	static def isBoolean (IO io) {
		switch io {
			BooleanInput,
			BooleanOutput : true
			default : false
		}
	}
	
	static def isNumber (IO io) {
		switch io {
			NumberInput,
			NumberOutput : true
			default : false
		}
	}
	
	static def isSub (IO io) {
		switch io {
			BooleanSubInput,
			BooleanSubOutputPort,
			NumberSubInput,
			NumberSubOutputPort : true
			default : false
		}
	}
	
	static def getIdentifier (IO io) {
		switch io {
			BooleanSubInput : io.identifier
			BooleanSubOutputPort : io.identifier
			NumberSubInput : io.identifier
			NumberSubOutputPort : io.identifier
			default : throw new RuntimeException("Not implemented")
		}
	}
	
	static def setIdentifier (IO io, String id) {
		switch io {
			BooleanSubInput : io.identifier = id
			BooleanSubOutputPort : io.identifier = id
			NumberSubInput : io.identifier = id
			NumberSubOutputPort : io.identifier = id
			default : throw new RuntimeException("Not implemented")
		}
	}
	
	static def IO createNewOfSameType (Operation op, IO io) {
		switch io {
			BooleanCarInput : op.newBooleanCarInput(0,0)
			BooleanCarOutput : op.newBooleanCarOutput(0,0)
			BooleanInputPort : op.newBooleanInputPort(0,0)
			BooleanOutputPort : op.newBooleanOutputPort(0,0)
			BooleanStaticInput : op.newBooleanStaticInput(0,0)
			BooleanSubCarInput : op.newBooleanSubCarInput(0,0)
			BooleanSubInputPort : op.newBooleanSubOutputPort(0,0)
			BooleanSubOutputPort : op.newBooleanSubInputPort(0,0)
			BooleanSubStaticInput : op.newBooleanSubStaticInput(0,0)
			NumberCarInput : op.newNumberCarInput(0,0)
			NumberCarOutput : op.newNumberCarOutput(0,0)
			NumberInputPort : op.newNumberInputPort(0,0)
			NumberOutputPort : op.newNumberOutputPort(0,0)
			NumberStaticInput : op.newNumberStaticInput(0,0)
			NumberSubCarInput : op.newNumberSubCarInput(0,0)
			NumberSubInputPort : op.newNumberSubOutputPort(0,0)
			NumberSubOutputPort : op.newNumberSubInputPort(0,0)
			NumberSubStaticInput : op.newNumberSubStaticInput(0,0)
			default : throw new RuntimeException("Not implemented")
		}
	}
}