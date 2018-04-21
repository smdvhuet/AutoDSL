package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleInputs
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.CommutableOperation

class CreateIO extends CincoPostCreateHook<IO> {
	
	override postCreate(IO io) {
		LayoutManager.rearrangePostCreate(io)
		if (io.container instanceof SubRuleInputs || io.container instanceof SubRuleOutputs) {
			val op = io.container as CommutableOperation
			switch (io) {
				NumberSubInput : io.identifier = "num_out" + op.numberSubInputs.size
				BooleanSubInput : io.identifier = "bool_out" + op.booleanSubInputs.size
				NumberSubOutput : io.identifier = "num_in" + op.numberSubOutputs.size
				BooleanSubOutput : io.identifier = "bool_in" + op.booleanSubOutputs.size
			}
		}
	}
	
}