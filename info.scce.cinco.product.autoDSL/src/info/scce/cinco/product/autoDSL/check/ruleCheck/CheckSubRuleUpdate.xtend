package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.SubRule
import org.eclipse.emf.common.util.EList

class CheckSubRuleUpdate extends RuleCheck{
	
	override check(Rule rule) {
		val subs = rule.subRules
		for (sub : subs) {
			val in = sub.rule.subRuleInputss
			val out = sub.rule.subRuleOutputss
			if (!in.isEmpty() || !out.isEmpty()) {
				val wantedInputs = if (!in.isEmpty()) in.get(0) else null
				val wantedOutputs = if (!out.isEmpty()) out.get(0) else null
			    checkIO(sub, sub.inputs as EList<?> as EList<IO>, wantedInputs?.inputs as EList<?> as EList<IO>)
			    checkIO(sub, sub.outputs as EList<?> as EList<IO>, wantedOutputs?.outputs as EList<?> as EList<IO>)
		    }
		}
	}

	/**
	 * Checks if find is in l based on identifier
	 */
	def containsSubIO(EList<IO> l, IO find) {
		l.filter(find.class).exists[switch it {
			NumberSubInput : streq((find as NumberSubInput).identifier, it.identifier)
			BooleanSubInput : streq((find as BooleanSubInput).identifier, it.identifier)
			NumberSubOutput : streq((find as NumberSubOutput).identifier, it.identifier)
			BooleanSubOutput : streq((find as BooleanSubOutput).identifier, it.identifier)
			default: false
		}]
	}

	def streq(String a, String b) {
		if (a == null) b == null else a.equals(b)
	}

	def checkIO(SubRule sub, EList<IO> current, EList<IO> wanted) {
	    for (wantedIO : wanted) {
	    	if (current == null || !current.containsSubIO(wantedIO)) {
	    		switch (wantedIO) {
	    			NumberSubInput : sub.newNumberSubInput(0,0).identifier = wantedIO.identifier
	    			BooleanSubInput : sub.newBooleanSubInput(0,0).identifier = wantedIO.identifier
	    			NumberSubOutput : sub.newNumberSubOutput(0,0).identifier = wantedIO.identifier
	    			BooleanSubOutput : sub.newBooleanSubOutput(0,0).identifier = wantedIO.identifier
	    		}
	    	}
	    }
	}
}