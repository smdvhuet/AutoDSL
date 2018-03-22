package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule

class CheckStart extends RuleCheck{
	
	override check(Rule rule) {
		//Checks if there is more than 1 operation without a predecessor
		rule.addWarning("Check not implemented yet, model may be missing a start node")
	}
}