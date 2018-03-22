package info.scce.cinco.product.autoDSL.check.autoDSLCheck

import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL
import info.scce.cinco.product.autoDSL.autodsl.mcam.modules.checks.AutoDSLCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class CheckForInvalidEdgesBetweenRules extends AutoDSLCheck{
	
	override check(AutoDSL model) {
		model.addWarning("Check not implemented yet, model may contain invalid edges between rules")
		//Check for edges between different states
		//Check for cycles
	}
}
