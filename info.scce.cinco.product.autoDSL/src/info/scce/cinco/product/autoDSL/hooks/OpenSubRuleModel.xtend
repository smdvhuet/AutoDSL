package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoDoubleClickAction
import info.scce.cinco.product.autoDSL.rule.rule.SubRule

class OpenSubRuleModel extends CincoDoubleClickAction<SubRule> {
	
	override execute(SubRule node) {
		node.rule.openEditor
	}

	override hasDoneChanges() {
		false
	}

}