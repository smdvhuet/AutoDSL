package info.scce.cinco.product.autoDSL.check.autoDSLCheck

import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL
import info.scce.cinco.product.autoDSL.autodsl.mcam.modules.checks.AutoDSLCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class CheckForInvalidRulesInStates extends AutoDSLCheck{
	
	override check(AutoDSL model) {
		for (state : model.states) {
			for (cNode : state.componentNodes) {
				if(hasGuardOutputs(cNode.rule)){
					state.addError("Rule models contained in states may not contain any BooleanGuardOutputs.")				
				}
			}
		}
	}
		
	def hasCarOutputs(Rule rule){
		if(!rule.directBooleanOutputs.empty)
			return true
		else if (!rule.directNumberOutputs.empty)
			return true
		else if (!rule.commutableOperations.filter[!it.booleanCarOutputs.empty || !it.numberCarOutputs.empty].empty)
			return true
		else if (!rule.nonCommutableOperations.filter[!it.booleanCarOutputs.empty || !it.numberCarOutputs.empty].empty)
			return true
		for(subrule : rule.subRules){
			if((subrule.rule).hasCarOutputs == true)
				return true
		}
		return false
	}
	
	def hasGuardOutputs(Rule rule){
		if(!rule.booleanGuardOutputs.empty)
			return true
		for(subrule : rule.subRules){
			if((subrule.rule).hasGuardOutputs == true) {
				subrule.addError("Subrules may not contain GuardOutputs")
				return true
			}
		}
		return false
	}
}