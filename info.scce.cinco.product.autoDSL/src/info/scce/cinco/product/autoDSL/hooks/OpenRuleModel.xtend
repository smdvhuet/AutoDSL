package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoDoubleClickAction
import info.scce.cinco.product.autoDSL.autodsl.autodsl.ComponentNode

class OpenRuleModel extends CincoDoubleClickAction<ComponentNode> {
	
	override execute(ComponentNode node) {
		node.rule.openEditor
	}

	override hasDoneChanges() {
		false
	}

}