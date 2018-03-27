package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule

class CheckStart extends RuleCheck{
	
	
	//Checks if there is more than 1 operation without a predecessor
	override check(Rule rule) {
		if(rule.allContainers.filter[x | x.getIncoming().length < 1].length > 1){
			rule.addError("Multiple start Nodes");
		}
	}
}