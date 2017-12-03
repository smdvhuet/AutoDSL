package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPreDeleteHook
import info.scce.cinco.product.autoDSL.rule.rule.Input
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class PreDeleteInput extends CincoPreDeleteHook<Input> {
	
	override preDelete(Input input) {
		LayoutManager.deleteInput(input.container as Operation, input);
	}
	
}