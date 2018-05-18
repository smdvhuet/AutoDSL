package info.scce.cinco.product.autoDSL.extensions

import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class SubRuleOutputsExtension {
		
	static def hasPortWithID(SubRuleOutputs op, String ID){
		for (port : op.inputs) {
			switch port{
				BooleanSubInput case port.identifier == ID : return true	
				NumberSubInput case port.identifier == ID :return true	
			}
		}
		return false
	}
		
	static def addRemainingSubInputs(IO newPort){
		for (outputNode : newPort.rootElement.subRuleOutputss) {
			//Create Port with same name in all subRuleOutput-Nodes
			switch newPort {
				BooleanSubInput :
					if (!outputNode.hasPortWithID(newPort.identifier)){
						val newSharedPort = outputNode.newBooleanSubInput(0,0)
						newSharedPort.identifier = newPort.identifier
					}
				NumberSubInput :
					if (!outputNode.hasPortWithID(newPort.identifier)){
						val newSharedPort = outputNode.newNumberSubInput(0,0)
						newSharedPort.identifier = newPort.identifier
					}
			}
		}
	}
	
	static def referenceSize(Operation op){
		val referenceObject = op.rootElement.subRuleOutputss.findFirst[it != op]
		if(referenceObject != null) referenceObject.inputs.size else 0
	}

}