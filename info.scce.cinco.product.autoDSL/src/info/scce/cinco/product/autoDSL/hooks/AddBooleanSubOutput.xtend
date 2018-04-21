package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleInputs

class AddBooleanSubOutput extends CincoCustomAction<SubRuleInputs> {

	override getName() {
		"Add Boolean Input"
	}

	override execute(SubRuleInputs inp) {
		inp.newBooleanSubOutput(0,0)
	}
}