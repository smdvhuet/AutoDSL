package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.SubRule
import org.eclipse.emf.common.util.BasicEList
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs
import info.scce.cinco.product.autoDSL.rule.rule.Rule

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