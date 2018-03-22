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
		
	def hasGuardOutputs(Rule rule){
		if(!rule.booleanGuardOutputs.empty)
			return true
		return false
	}
}