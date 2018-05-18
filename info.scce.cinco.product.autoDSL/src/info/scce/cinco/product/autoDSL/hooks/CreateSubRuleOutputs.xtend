package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

import static extension info.scce.cinco.product.autoDSL.extensions.SubRuleOutputsExtension.*

class CreateSubRuleOutputs extends CincoPostCreateHook<SubRuleOutputs> {
	
	override postCreate(SubRuleOutputs op) {
		val output = op.rootElement.subRuleOutputss.findFirst[it != op]
		if(output != null){ 
			for (port : output.inputs) {
				port.addRemainingSubInputs
			}	
		}
	}

}