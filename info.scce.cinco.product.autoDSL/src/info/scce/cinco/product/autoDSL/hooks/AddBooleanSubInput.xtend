package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

import static extension info.scce.cinco.product.autoDSL.extensions.SubRuleOutputsExtension.*

class AddBooleanSubInput extends CincoCustomAction<SubRuleOutputs> {

	override getName() {
		"Add Boolean Output"
	}

	override execute(SubRuleOutputs outputs) {
		val newPort = outputs.newBooleanSubInput(0,0)
		newPort.addRemainingSubInputs(outputs)
	}

}