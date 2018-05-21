package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.BooleanGuardOutput
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.SubRule

class CheckRuleType extends RuleCheck{
	
	override check(Rule rule) {
		val hasSubRuleOutputs = !rule.subRuleOutputss.empty
		val isSubRule = !rule.subRuleInputss.empty || hasSubRuleOutputs 
		if(rule.isGuardRule && isSubRule)
			rule.addError("Rule contains both a GuardOutput and SubRule-IO")
		if(rule.isGuardRule && rule.containsCarOutputs)
			rule.addError("This Rule is a Guard and must therefore not contain CarOutputs")
		if(rule.isGuardRule || isSubRule){
			//Check if all paths end with correct outputs
			for(node : rule.operations){
				if(node.successors.empty){
					if(rule.isGuardRule && !(node instanceof BooleanGuardOutput) && !((node instanceof SubRule) && (node as SubRule).rule.isGuardRule))
						rule.addError("Rule contains a path that doesn't end with a GuardOutput-Node, although it contains one or more GuardOutputs")
					if(hasSubRuleOutputs && !(node instanceof SubRuleOutputs))
						rule.addError("Rule contains a path that doesn't end with a SubRuleOutputs-Node, although it contains one or more SubRuleOutputs")
				}
			}
		}
		if(!rule.subRules.filter[it.rule.isGuardRule].filter[!it.successors.empty].empty)
			rule.addError("Guards used as SubRules must not have outgoing ControllFlow")
	}
	
	private def boolean containsCarOutputs(Rule rule) {
		!rule.operations.map[it.outputs].flatten.filter[it instanceof BooleanCarOutput].empty ||
		!rule.operations.map[it.outputs].flatten.filter[it instanceof NumberCarOutput].empty ||		
		!rule.subRules.map[it.rule].filter[it.containsCarOutputs].empty
	}
	
	private def isGuardRule(Rule rule) {
		!rule.booleanGuardOutputs.empty
	}
}