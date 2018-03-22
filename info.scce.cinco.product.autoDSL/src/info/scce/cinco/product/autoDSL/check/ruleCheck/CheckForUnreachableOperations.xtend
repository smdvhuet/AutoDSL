package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule

class CheckForUnreachableOperations extends RuleCheck{
	
	override check(Rule rule) {
		rule.addWarning("Check not implemented yet, model may contain unreachable nodes")
	}
}