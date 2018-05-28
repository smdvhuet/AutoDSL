package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleInputs

class AddNumberSubOutput extends CincoCustomAction<SubRuleInputs> {

	override getName() {
		"Add Number Input"
	}

	override execute(SubRuleInputs inp) {
		inp.newNumberSubOutputPort(0,0)
	}
}