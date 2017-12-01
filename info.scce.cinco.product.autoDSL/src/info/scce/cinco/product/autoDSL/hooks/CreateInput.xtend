package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.Input
import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class CreateInput extends CincoPostCreateHook<Input> {
	
	override postCreate(Input input) {
		LayoutManager.insertInput(input.container as Operation, input)
	}
	
}