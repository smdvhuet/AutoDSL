package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanProgrammableNodeInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutput
import info.scce.cinco.product.autoDSL.rule.rule.NumberProgrammableNodeInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
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
				NumberSubInput : {
					io.identifier = "num_out" + op.numberSubInputs.size
					if(op.inputs.size > op.referenceSize){
						io.addRemainingSubInputs	
					}
				}
				BooleanSubInput : {
					io.identifier = "bool_out" + op.booleanSubInputs.size
					if(op.inputs.size > op.referenceSize){
						io.addRemainingSubInputs	
					}
				}
				NumberOutput : io.identifier = "num_in" + op.numberOutputs.size
				BooleanOutput : io.identifier = "bool_in" + op.booleanOutputs.size
			}
		}
		switch io {
			BooleanProgrammableNodeInput : io.identifier = "bool_in" + io.operation.booleanProgrammableNodeInputs.size
			NumberProgrammableNodeInput : io.identifier = "num_in" + io.operation.numberProgrammableNodeInputs.size
		}
	}
}
