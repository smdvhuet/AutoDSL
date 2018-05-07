package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleInputs
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class CreateIO extends CincoPostCreateHook<IO> {
	
	override postCreate(IO io) {
		LayoutManager.rearrangePostCreate(io)
		if (io.container instanceof SubRuleInputs || io.container instanceof SubRuleOutputs) {
			val op = io.operation
			switch (io) {
				NumberSubInput : {
					io.identifier = "num_out" + op.numberSubInputs.size
					
					//TODO refactor
					val outputs = io.operation as SubRuleOutputs
					val model = outputs.rootElement
					for (outputNode : model.subRuleOutputss) {
						//Create Port with same name in all subRuleOutput-Nodes
						if (!outputNode.hasPortWithID(io.identifier)){
							val newSharedPort = outputNode.newNumberSubInput(0,0)
							newSharedPort.identifier = io.identifier
						}
					}
				}
				BooleanSubInput : {
					io.identifier = "bool_out" + op.booleanSubInputs.size
					
					//TODO refactor
					val outputs = io.operation as SubRuleOutputs
					val model = outputs.rootElement
					for (outputNode : model.subRuleOutputss) {
						//Create Port with same name in all subRuleOutput-Nodes
						if (!outputNode.hasPortWithID(io.identifier)){
							val newSharedPort = outputNode.newBooleanSubInput(0,0)
							newSharedPort.identifier = io.identifier
						}
					}
				}
				NumberSubOutput : io.identifier = "num_in" + op.numberSubOutputs.size
				BooleanSubOutput : io.identifier = "bool_in" + op.booleanSubOutputs.size
			}
		}
	}
	
	//TODO refactor
	def hasPortWithID(SubRuleOutputs op, String ID){
		for (port : op.inputs) {
			switch port{
					BooleanSubInput : 
						if(port.identifier == ID)
							return true	
					NumberSubInput :
						if(port.identifier == ID)
							return true	
			}
		}
		return false
	}
}