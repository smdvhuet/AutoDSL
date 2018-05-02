package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoPostValueChangeListener
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

class UpdateSubRuleOutputs extends CincoPostValueChangeListener<IO> {
	
	override canHandleChange(IO arg0) {
		//TODO: auto-generated method stub
		true
	}
	
	override handleChange(IO io) {
//		val container = io.container as SubRuleOutputs
//		val subRuleOutputs = io.rootElement.subRuleOutputss.filter[it != container]
//		for (subRuleOutput : subRuleOutputs) {
//			val booleanPorts = subRuleOutput.booleanSubInputs.filter[!container.booleanSubInputs.map[identifier].contains(it.identifier)]
//			val numberPorts = subRuleOutput.numberSubInputs.filter[!container.numberSubInputs.map[identifier].contains(it.identifier)]
//			for (port : booleanPorts) {
//				port.identifier = (io as BooleanSubInput).identifier
//			}
//			for (port : numberPorts) {
//				port.identifier = (io as NumberSubInput).identifier
//			}
//		}
	}
}