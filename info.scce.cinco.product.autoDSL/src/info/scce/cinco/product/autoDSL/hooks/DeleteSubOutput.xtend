package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPreDeleteHook
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.Input
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput

class DeleteSubOutput extends CincoPreDeleteHook<Input> {
	
	override preDelete(Input input) {
		val model = input.rootElement
		val otherOutputs = model.subRuleOutputss

		for (otherOutput : otherOutputs) {
			val ports = otherOutput.inputs
			for (port : ports) {
				switch(input){
					BooleanSubInput: if(input.hasSameIdentifier(port)) {
						port.delete()
					}
					NumberSubInput: if(input.hasSameIdentifier(port)) {
						port.delete()
					}
				}
			}
			
		}
	}

	def hasSameIdentifier(BooleanSubInput boolInput, Input input){
		switch(input){
			BooleanSubInput : 
				if(input.identifier == boolInput.identifier)
					return true	
			NumberSubInput :
				if(input.identifier == boolInput.identifier)
					return true	
		}
		return false
	}
	
	def hasSameIdentifier(NumberSubInput numberInput, Input input){
		switch(input){
			BooleanSubInput : 
				if(input.identifier == numberInput.identifier)
					return true	
			NumberSubInput :
				if(input.identifier == numberInput.identifier)
					return true	
		}
		return false
	}
}