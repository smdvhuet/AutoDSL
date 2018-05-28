package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

class AddBooleanSubInput extends CincoCustomAction<SubRuleOutputs> {

	override getName() {
		"Add Boolean Output"
	}
	
	override execute(SubRuleOutputs outputs) {
		outputs.newBooleanSubInputPort(0,0)
	}
}