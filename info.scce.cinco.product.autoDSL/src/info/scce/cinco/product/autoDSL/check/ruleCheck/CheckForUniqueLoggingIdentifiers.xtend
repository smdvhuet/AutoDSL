package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import java.util.HashSet

class CheckForUniqueLoggingIdentifiers extends RuleCheck {
	
	override check(Rule model) {
		val l = new HashSet<String>
		val loggingIdentifiers = model.operations.map[inputs].flatten.map[loggingIdentifier].filter[!nullOrEmpty].toList
		loggingIdentifiers.addAll(model.operations.map[outputs].flatten.map[loggingIdentifier].filter[!nullOrEmpty].toList)
		for(loggingIdentifier:loggingIdentifiers){
			if(!l.add(loggingIdentifier)) model.addError("Duplicate loggingIdentifier found: " + loggingIdentifier)
		}
	}
}