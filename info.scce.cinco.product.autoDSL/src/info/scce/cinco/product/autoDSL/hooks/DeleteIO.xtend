package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPreDeleteHook
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class DeleteIO extends CincoPreDeleteHook<IO> {
	
	override preDelete(IO io) {
		LayoutManager.rearrangePreDelete(io)
		switch io {
			BooleanSubInput,
			NumberSubInput : io.deleteInAllSubRuleOutputs
		}
	}
	
	def deleteInAllSubRuleOutputs(IO io){
		val subRuleOutputs = io.rootElement.subRuleOutputss
		for (subRuleOutput : subRuleOutputs) {
			val ports = subRuleOutput.inputs.filter[it != io]
			for (port : ports) {
				if(io.hasSameIdentifier(port)) {
					switch port {
						BooleanSubInput : port.identifier = TEMPORARY_IDENTIFIER 
						NumberSubInput : port.identifier = TEMPORARY_IDENTIFIER
					}
					port.delete
				}
			}
			
		}
	}

	def hasSameIdentifier(IO io, IO port){
		val ioIdentifier = switch io {
			BooleanSubInput :  io.identifier
			NumberSubInput : io.identifier
		}
		val portIdentifier = switch port {
			BooleanSubInput : port.identifier
			NumberSubInput : port.identifier
		}
		ioIdentifier == portIdentifier
	}
}