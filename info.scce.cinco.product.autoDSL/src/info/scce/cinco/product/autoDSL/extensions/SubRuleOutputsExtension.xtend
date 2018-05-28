package info.scce.cinco.product.autoDSL.extensions

import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class SubRuleOutputsExtension {
		
	static def hasPortWithID(SubRuleOutputs op, String ID){
		for (port : op.inputs) {
			switch port{
				case port.identifier == ID : return true
			}
		}
		return false
	}
		
	static def addRemainingSubInputs(IO newPort){
		for (outputNode : newPort.rootElement.subRuleOutputss) {
			//Create Port with same name in all subRuleOutput-Nodes
			if (!outputNode.hasPortWithID(newPort.identifier)){
				outputNode.createNewOfSameType(newPort).identifier = newPort.identifier
			}
		}
	}
	
	static def referenceSize(Operation op){
		val referenceObject = op.rootElement.subRuleOutputss.findFirst[it != op]
		if(referenceObject != null) referenceObject.inputs.size else 0
	}

}