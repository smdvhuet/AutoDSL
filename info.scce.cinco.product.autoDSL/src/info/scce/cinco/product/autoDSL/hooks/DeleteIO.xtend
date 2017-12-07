package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPreDeleteHook
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class DeleteIO extends CincoPreDeleteHook<IO> {
	
	override preDelete(IO io) {
		LayoutManager.rearrangeAfterDelete(io.container as Operation, io)
	}
	
}