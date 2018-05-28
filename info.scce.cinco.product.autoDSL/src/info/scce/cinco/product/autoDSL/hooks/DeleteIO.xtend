package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPreDeleteHook
import info.scce.cinco.product.autoDSL.rule.rule.IO

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class DeleteIO extends CincoPreDeleteHook<IO> {
	
	override preDelete(IO io) {
		LayoutManager.rearrangePreDelete(io)
		switch io {
			case io.isSub : io.deleteInAllSubRuleOutputs
		}
	}
	
	def deleteInAllSubRuleOutputs(IO io){
		val subRuleOutputs = io.rootElement.subRuleOutputss
		for (subRuleOutput : subRuleOutputs) {
			val ports = subRuleOutput.inputs.filter[it != io]
			for (port : ports) {
				if(io.identifier == port.identifier) {
					port.identifier = TEMPORARY_IDENTIFIER 
					port.delete
				}
			}
		}
	}
}
