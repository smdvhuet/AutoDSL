package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule

class CheckSubRuleIOIdentifiers extends RuleCheck {
	
	override check(Rule rule) {
		rule.addWarning("not Implemented yet");
	}
	
	//Überprüfe ob SubRuleInput / -Output Knoten einzigartige Namen für Input und Outputs haben.
}