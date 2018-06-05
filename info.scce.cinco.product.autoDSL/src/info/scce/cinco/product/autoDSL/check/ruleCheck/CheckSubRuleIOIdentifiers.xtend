package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import java.util.HashSet

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class CheckSubRuleIOIdentifiers extends RuleCheck {
	
	override check(Rule rule) {
		val l = new HashSet<String>();
		rule.subRuleInputss.forEach[it.outputs.forEach[
			val id = it.identifier
			if (id.empty)
				it.addError("Empty identifier found")
			else if (!l.add(it.identifier))
				it.addError("Duplicate identifier found: " + id)
			]
			l.clear
		]
		rule.subRuleOutputss.forEach[it.inputs.forEach[
			val id = it.identifier
			if (id.empty)
				it.addError("Empty identifier found")
			else if (!l.add(it.identifier))
				it.addError("Duplicate identifier found: " + id)
			]
			l.clear
		]
	}
}