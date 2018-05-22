package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.StartNode

class CheckStart extends RuleCheck{
	
	
	//Checks if there is more than 1 operation without a predecessor
	override check(Rule rule) {
		if(rule.allNodes.filter[x | x instanceof StartNode].length < 1){
			rule.addError("No StartNode found");
		}
	}
}