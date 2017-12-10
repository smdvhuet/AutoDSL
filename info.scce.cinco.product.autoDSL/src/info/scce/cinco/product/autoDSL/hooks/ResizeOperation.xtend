package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostResizeHook
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class ResizeOperation extends CincoPostResizeHook<Operation> {
	
	override postResize(Operation op, int direction, int width, int height) {
		LayoutManager.resizeOperation(op, width)
	}
	
}