package info.scce.cinco.product.autoDSL.check.autoDSLCheck

import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL
import info.scce.cinco.product.autoDSL.autodsl.mcam.modules.checks.AutoDSLCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class CheckForUnreachableStates extends AutoDSLCheck{
	
	override check(AutoDSL model) {
		for (state : model.states)
			state.addWarning("Check not implemented yet, model may contain unreachable states")
	}
}