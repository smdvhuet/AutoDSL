package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoDoubleClickAction
import info.scce.cinco.product.autoDSL.autodsl.autodsl.ComponentNode

class openRuleModel extends CincoDoubleClickAction<ComponentNode> {
	
	override execute(ComponentNode node) {
		node.rule.openEditor
	}


	}