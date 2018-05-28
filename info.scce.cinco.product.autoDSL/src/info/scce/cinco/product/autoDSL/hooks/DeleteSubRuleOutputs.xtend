package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPreDeleteHook
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class DeleteSubRuleOutputs extends CincoPreDeleteHook<SubRuleOutputs> {
	
	override preDelete(SubRuleOutputs op) {
		for (input : op.inputs){
			input.identifier = TEMPORARY_IDENTIFIER
			input.delete
		}
	}
}