package info.scce.cinco.product.autoDSL.check.autoDSLCheck

import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL
import info.scce.cinco.product.autoDSL.autodsl.mcam.modules.checks.AutoDSLCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class CheckForInvalidRulesInGuards extends AutoDSLCheck{
	
	override check(AutoDSL model) {
		for (guard : model.guards) {
			for (cNode : guard.componentNodes) {
				if(hasCarOutputs(cNode.rule)){
					guard.addError("Rule models contained in guards may not contain any car outputs.")				
				}
				if(!hasGuardOutputs(cNode.rule)){
					guard.addError("Rule models contained in guards must contain at least one BooleanGuardOutput")
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