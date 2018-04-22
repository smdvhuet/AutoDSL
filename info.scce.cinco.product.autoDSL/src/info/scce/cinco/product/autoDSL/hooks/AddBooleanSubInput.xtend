package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput

class AddBooleanSubInput extends CincoCustomAction<SubRuleOutputs> {

	override getName() {
		"Add Boolean Output"
	}

	override execute(SubRuleOutputs outputs) {
		val newPort = outputs.newBooleanSubInput(0,0)
		val model = outputs.rootElement
		for (outputNode : model.subRuleOutputss) {
			//Create Port with same name in all subRuleOutput-Nodes
			if (!outputNode.hasPortWithID(newPort.identifier)){
				val newSharedPort = outputNode.newBooleanSubInput(0,0)
				newSharedPort.identifier = newPort.identifier
			}
		}
	}
	
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