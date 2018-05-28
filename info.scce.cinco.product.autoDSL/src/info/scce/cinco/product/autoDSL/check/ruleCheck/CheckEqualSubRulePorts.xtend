package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.SubRuleOutputs

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class CheckEqualSubRulePorts extends RuleCheck {
	
	override check(Rule model) {
		val outputs = model.subRuleOutputss
		if(outputs.size > 1){
			val firstOutput = outputs.get(0)
			var outputsWithoutFirstElement = outputs.drop(1)
			for (output : outputsWithoutFirstElement) {
				if(!firstOutput.hasSamePorts(output)){
					output.addError("All SubRuleOutputs need the same input Ports")
				}
			}
		}
	}
	
	def hasSamePorts(SubRuleOutputs firstOutput, SubRuleOutputs secondOutput){
		val firstOutputBooleanIdentifiers = firstOutput.inputs.filter[isBoolean].map[identifier].toList
		val firstOutputNumberIdentifiers = firstOutput.inputs.filter[isNumber].map[identifier].toList
		val secondOutputBooleanIdentifiers = secondOutput.inputs.filter[isBoolean].map[identifier].toList
		val secondOutputNumberIdentifiers = secondOutput.inputs.filter[isNumber].map[identifier].toList
		
		firstOutputNumberIdentifiers.containsAll(secondOutputNumberIdentifiers) &&
		secondOutputNumberIdentifiers.containsAll(firstOutputNumberIdentifiers) &&
		firstOutputBooleanIdentifiers.containsAll(secondOutputBooleanIdentifiers) &&
		secondOutputBooleanIdentifiers.containsAll(firstOutputBooleanIdentifiers)
	}
}