package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule

class CheckForSingleOutputOnProgrammableNode extends RuleCheck {
	
	override check(Rule model) {
		val progNodes = model.programmableNodes
		for(progNode:progNodes){
			if(progNode.outputs.size > 1){
				progNode.addError("Only 1 Output per Programmable Node allowed")
			}
		}
	}
	
}