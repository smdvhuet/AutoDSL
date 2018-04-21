package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutput
import java.util.HashSet

class CheckSubRuleIOIdentifiers extends RuleCheck {
	
	override check(Rule rule) {
		val l = new HashSet<String>();
		rule.subRuleInputss.forEach[it.outputs.forEach[
			val id = it.identifier
			if (id == null || id.empty)
				it.addError("Empty identifier found")
			else if (!l.add(it.identifier))
				it.addError("Duplicate identifier found: " + id)
		]]
		rule.subRuleOutputss.forEach[it.inputs.forEach[
			val id = it.identifier
			if (id == null || id.empty)
				it.addError("Empty identifier found")
			else if (!l.add(it.identifier))
				it.addError("Duplicate identifier found: " + id)
		]]		
	}

	def getIdentifier(IO io) {
		switch (io) {
			NumberSubInput : return io.identifier
			BooleanSubInput : return io.identifier
			NumberSubOutput : return io.identifier
			BooleanSubOutput : return io.identifier
			default : null
		}
	}
}