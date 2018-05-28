package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoPostValueChangeListener
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*
import static extension info.scce.cinco.product.autoDSL.extensions.SubRuleOutputsExtension.*

class UpdateSubRuleOutputs extends CincoPostValueChangeListener<IO> {
	
	override canHandleChange(IO io) {
		val op = io.operation
		if(op.inputs.size != op.referenceSize){
			return false
		}
		switch io {
			case io.isSub && io.isBoolean : !io.identifier.equals(TEMPORARY_IDENTIFIER) && !io.identifier.equals("bool_out" + io.operation.booleanInputs.size)
			case io.isSub && io.isNumber : !io.identifier.equals(TEMPORARY_IDENTIFIER) && !io.identifier.equals("num_out" + io.operation.numberInputs.size)
			default : true
		}
	}
	
	override handleChange(IO io) {
		if (!io.canHandleChange) {return} //Method somehow not called otherwise
		val container = io.container as SubRuleOutputs
		val subRuleOutputs = io.rootElement.subRuleOutputss.filter[it != container]
		for (subRuleOutput : subRuleOutputs) {
			val updatedIdentifier = io.identifier
			val ports = switch io {
				case io.isBoolean : subRuleOutput.booleanInputs.filter[!container.booleanInputs.map[identifier].contains(it.identifier)]
				case io.isNumber : subRuleOutput.numberInputs.filter[!container.numberInputs.map[identifier].contains(it.identifier)]
			}
			for (port : ports) {
				port.identifier = updatedIdentifier
			}
		}
	}
}
