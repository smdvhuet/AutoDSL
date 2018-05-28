package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleInputs
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*
import static extension info.scce.cinco.product.autoDSL.extensions.SubRuleOutputsExtension.*

class CreateIO extends CincoPostCreateHook<IO> {
	
	override postCreate(IO io) {
		LayoutManager.rearrangePostCreate(io)
		if (io.container instanceof SubRuleInputs || io.container instanceof SubRuleOutputs) {
			val op = io.operation
			switch io {
				NumberSubInputPort : {
					io.identifier = "num_out" + op.numberSubInputPorts.size
					if(op.inputs.size > op.referenceSize){
						io.addRemainingSubInputs	
					}
				}
				BooleanSubInputPort : {
					io.identifier = "bool_out" + op.booleanSubInputPorts.size
					if(op.inputs.size > op.referenceSize){
						io.addRemainingSubInputs	
					}
				}
				NumberSubOutputPort : io.identifier = "num_in" + op.numberSubOutputPorts.size
				BooleanSubOutputPort : io.identifier = "bool_in" + op.booleanSubOutputPorts.size
			}
		}
	}
}
