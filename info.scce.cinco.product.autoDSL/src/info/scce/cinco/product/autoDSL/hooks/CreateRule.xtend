package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.Rule

class CreateRule extends CincoPostCreateHook<Rule> {
	
	override postCreate(Rule rule) {
		rule.newStartNode(0,0)
	}
}