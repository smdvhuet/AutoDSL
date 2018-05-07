package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoPostValueChangeListener
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class UpdateSubRuleOutputs extends CincoPostValueChangeListener<IO> {
	
	override canHandleChange(IO io) {
		//TODO prevent duplicate identifiers
		switch io {
			BooleanSubInput : !io.identifier.equals(TEMPORARY_IDENTIFIER) && !io.identifier.equals("bool_out" + io.operation.booleanSubInputs.size)
			NumberSubInput : !io.identifier.equals(TEMPORARY_IDENTIFIER) && !io.identifier.equals("num_out" + io.operation.numberSubInputs.size)
			default : true
		}
	}
	
	override handleChange(IO io) {
		if (!io.canHandleChange) {return} //Method somehow not called otherwise
		val container = io.container as SubRuleOutputs
		val subRuleOutputs = io.rootElement.subRuleOutputss.filter[it != container]
		for (subRuleOutput : subRuleOutputs) {
			val updatedIdentifier = switch io {
				BooleanSubInput : io.identifier
				NumberSubInput : io.identifier
			}
			val ports = switch io {
				BooleanSubInput : subRuleOutput.booleanSubInputs.filter[!container.booleanSubInputs.map[identifier].contains(it.identifier)]
				NumberSubInput : subRuleOutput.numberSubInputs.filter[!container.numberSubInputs.map[identifier].contains(it.identifier)]
			}
			for (port : ports) {
				switch port {
					BooleanSubInput : {
						println(port.identifier)
						port.identifier = updatedIdentifier
					}
					NumberSubInput : port.identifier = updatedIdentifier
				}
			}
		}
	}
}