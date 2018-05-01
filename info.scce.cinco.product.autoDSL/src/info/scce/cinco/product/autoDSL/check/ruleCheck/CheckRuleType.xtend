package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.BooleanGuardOutput
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

class CheckRuleType extends RuleCheck{
	
	override check(Rule rule) {
		val isGuardRule = !rule.booleanGuardOutputs.empty
		val isSubRule = !rule.subRuleInputss.empty || !rule.subRuleOutputss.empty
		if(isGuardRule && isSubRule)
			rule.addError("Rule contains both a GuardOutput and SubRule-IO")
		if(isGuardRule || isSubRule){
			//Check if all paths end with correct outputs
			for(node : rule.operations){
				if(node.successors.empty){
					if(isGuardRule && !(node instanceof BooleanGuardOutput))
						rule.addError("Rule contains a path that doesn't end with a GuardOutput-Node, although it contains one or more GuardOutputs")
					if(isSubRule && !(node instanceof SubRuleOutputs))
						rule.addError("Rule contains a path that doesn't end with a SubRuleOutputs-Node, although it contains one or more SubRuleIn/Outputs")
				}
			}
		}
	}
}