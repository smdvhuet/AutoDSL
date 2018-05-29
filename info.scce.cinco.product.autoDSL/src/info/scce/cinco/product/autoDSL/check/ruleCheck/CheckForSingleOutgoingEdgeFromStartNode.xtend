package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule

class CheckForSingleOutgoingEdgeFromStartNode extends RuleCheck{
	
	override check(Rule model) {
		val startNodes = model.startNodes
		for(startNode:startNodes){
			if(startNode.outgoing.size > 1){
				startNode.addError("Only 1 outgoing Edge per Start Node allowed")
			}
		}
	}
	
}