package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.CommutableOperation

class CreateCommutableBooleanOp extends CincoPostCreateHook<CommutableOperation> {
	
	override  postCreate(CommutableOperation droppedNode) {
		LayoutManager.insertBooleanInput(droppedNode)
		LayoutManager.insertBooleanInput(droppedNode)
		LayoutManager.insertBooleanOutput(droppedNode)
	}
}