package info.scce.cinco.product.autoDSL.check.ruleCheck

import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.SubRule
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.BasicEList

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

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
			NumberSubInputPort  :  if (find instanceof NumberSubOutputPort)  streq((find as NumberSubOutputPort).identifier, it.identifier) else false
			BooleanSubInputPort :  if (find instanceof BooleanSubOutputPort) streq((find as BooleanSubOutputPort).identifier, it.identifier) else false
			NumberSubOutputPort :  if (find instanceof NumberSubInputPort)   streq((find as NumberSubInputPort).identifier, it.identifier) else false
			BooleanSubOutputPort : if (find instanceof BooleanSubInputPort)  streq((find as BooleanSubInputPort).identifier, it.identifier) else false
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
				sub.createNewOfSameType(wantedIO).identifier = wantedIO.identifier
			} else {
				keep.add(found);
			}
		}
		// Delete ones that are in current but not wanted
		current.filter[!keep.contains(it)].forEach[delete]
	}
}