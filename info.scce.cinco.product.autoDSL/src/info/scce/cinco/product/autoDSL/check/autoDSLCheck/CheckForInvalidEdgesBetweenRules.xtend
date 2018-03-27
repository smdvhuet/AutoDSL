package info.scce.cinco.product.autoDSL.check.autoDSLCheck

import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL
import info.scce.cinco.product.autoDSL.autodsl.mcam.modules.checks.AutoDSLCheck
import org.eclipse.emf.common.util.EList
import info.scce.cinco.product.autoDSL.autodsl.autodsl.ComponentNode
import info.scce.cinco.product.autoDSL.autodsl.autodsl.State
import java.util.HashMap
import graphmodel.Node
import java.util.HashSet

class CheckForInvalidEdgesBetweenRules extends AutoDSLCheck {

	override check(AutoDSL model) {
		model.states.forEach[
			it.componentNodes.checkRulesInState(it)
		]
	}

	def checkRulesInState(EList<ComponentNode> l, State state) {
		if (l.empty) {
			return;
		}
		
		// Check for edges into different states
		if (l.exists[it.outgoing.exists[it.targetElement.container != state]]) {
			state.addError("Rule must not be connected to rule in different state")
			return;
		}
		
		if (l.exists[node | node.outgoing.exists[it.targetElement == node]]) {
			state.addError("Must not link rule to itself")
			return;
		}
		
		// Check for cycles
		val start = l.filter[it.incoming.empty]
		if (start.isEmpty()) {
			state.addError("Rule prioritization in state must not contain cycles")
		} else if (start.size > 1) {
			state.addError("Ensure there's a connection between all rules in the state")
		} else {
			var cur = start.get(0) as Node
			val seen = new HashSet<Node>()
			while (cur != null) {
				if (!seen.add(cur)) {
					state.addError("Rule prioritization in state must not contain cycles")
				}
				if (!cur.outgoing.empty) {
					if (cur.outgoing.size > 1) {
						state.addError("Rule must only be connected to a single other rule in state")
						return;
					}
					cur = cur.outgoing.get(0).targetElement
				} else {
					cur = null
				}
			}
		}
	}
}
