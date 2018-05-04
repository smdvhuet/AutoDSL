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
import org.eclipse.emf.common.util.BasicEList

class CheckSubRuleUpdate extends RuleCheck{
	
	override check(Rule rule) {
		
		val subs = rule.subRules
		for (sub : subs) {
			println(sub.label)
			val in = sub.rule.subRuleInputss
			val out = sub.rule.subRuleOutputss
			if (!in.isEmpty() || !out.isEmpty()) {
				if (!in.isEmpty()) {
					val wantedInputs = in.get(0)
					checkIO(sub, sub.inputs as EList<?> as EList<IO>, wantedInputs?.outputs as EList<?> as EList<IO>)
				}
				if (!out.isEmpty()) {
					val wantedOutputs = out.get(0)
			    	checkIO(sub, sub.outputs as EList<?> as EList<IO>, wantedOutputs?.inputs as EList<?> as EList<IO>) 
				}
		    }
		}
	}

	/**
	 * Finds find in l based on identifier
	 */
	def findSubIO(EList<IO> l, IO find) {
		l.findFirst[switch it {
			NumberSubInput  :  if (find instanceof NumberSubOutput)  streq((find as NumberSubOutput).identifier, it.identifier) else false
			BooleanSubInput :  if (find instanceof BooleanSubOutput) streq((find as BooleanSubOutput).identifier, it.identifier) else false
			NumberSubOutput :  if (find instanceof NumberSubInput)   streq((find as NumberSubInput).identifier, it.identifier) else false
			BooleanSubOutput : if (find instanceof BooleanSubInput)  streq((find as BooleanSubInput).identifier, it.identifier) else false
			default: false
		}]
	}

	def streq(String a, String b) {
		if (a == null) b == null else a.equals(b)
	}

	def checkIO(SubRule sub, EList<IO> current, EList<IO> wanted) {
		val keep = new BasicEList<IO>();
	    for (wantedIO : wanted) {
	    	val found = current?.findSubIO(wantedIO)
	    	if (found == null) {
	    		switch wantedIO {
	    			NumberSubInput : sub.newNumberSubOutput(0,0).identifier = wantedIO.identifier
	    			BooleanSubInput : sub.newBooleanSubOutput(0,0).identifier = wantedIO.identifier
	    			NumberSubOutput : sub.newNumberSubInput(0,0).identifier = wantedIO.identifier
	    			BooleanSubOutput : sub.newBooleanSubInput(0,0).identifier = wantedIO.identifier
	    		}
	    	} else {
	    		keep.add(found);
	    	}
	    }
	    // Delete ones that are in current but not wanted
	    current.filter[!keep.contains(it)].forEach[it.delete()]
	}
}