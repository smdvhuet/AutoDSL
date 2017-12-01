package info.scce.cinco.product.autoDSL.check

import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL
import info.scce.cinco.product.autoDSL.autodsl.mcam.modules.checks.AutoDSLCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class CheckForInvalidOutputsInGuards extends AutoDSLCheck{
	
	override check(AutoDSL model) {
		model.offStates.forEach[addError("test")]
		model.guards.filter[!it.componentNodes.filter[checkRuleForExistanceCarOutputs(it.rule)].empty].forEach[addError("Rule models contained in guards may not contain any car outputs.")]
	}
		
	def checkRuleForExistanceCarOutputs(Rule rule){
		if(!rule.booleanOutputNodes.empty)
			return false
		else if (!rule.numberOutputNodes.empty)
			return false
		else if (!rule.commutableOperations.filter[!it.booleanCarOutputs.empty || !it.numberCarOutputs.empty].empty)
			return false
		else if (!rule.nonCommutableOperations.filter[!it.booleanCarOutputs.empty || !it.numberCarOutputs.empty].empty)
			return false
		else
			return true
	}
	
}