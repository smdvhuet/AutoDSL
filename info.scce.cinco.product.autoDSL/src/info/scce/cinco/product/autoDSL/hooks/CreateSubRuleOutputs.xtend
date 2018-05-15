package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

import static extension info.scce.cinco.product.autoDSL.extensions.SubRuleOutputsExtension.*

class CreateSubRuleOutputs extends CincoPostCreateHook<SubRuleOutputs> {
	
	override postCreate(SubRuleOutputs op) {
		val model = op.rootElement
		val otherOutputs = model.subRuleOutputss

		for (output : otherOutputs) {
			val ports = output.inputs
			for (port : ports) {
				// Check if the new operation has this port already
				switch port{
					BooleanSubInput : 
					if(!op.hasPortWithID(port.identifier)){
						val newInput = op.newBooleanSubInput(0,0)
						newInput.identifier = port.identifier
					}
					NumberSubInput :
					if(!op.hasPortWithID(port.identifier)){
						val newInput = op.newNumberSubInput(0,0)
						newInput.identifier = port.identifier
					}
				}
				
			}
			
		}
	}

}