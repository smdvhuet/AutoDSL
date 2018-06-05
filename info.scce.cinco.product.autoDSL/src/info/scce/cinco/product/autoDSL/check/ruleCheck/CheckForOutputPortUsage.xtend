package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.Rule

class CheckForOutputPortUsage extends RuleCheck {
	
	override check(Rule model) {
		val ports = model.operations.map[outputs].flatten
		for(port:ports){
			switch port {
				BooleanOutputPort case port.outgoing.empty,
				BooleanSubOutputPort case port.outgoing.empty,
				NumberOutputPort case port.outgoing.empty,
				NumberSubOutputPort case port.outgoing.empty : if(!port.loggingIdentifier.nullOrEmpty) port.addWarning("Output never used besides logging!") else  port.addWarning("Output never used!")
			}
		}
	}
}