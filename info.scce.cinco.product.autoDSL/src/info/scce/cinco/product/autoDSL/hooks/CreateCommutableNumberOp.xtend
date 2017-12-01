package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class CreateCommutableNumberOp extends CincoPostCreateHook<Operation> {
	
	override  postCreate(Operation droppedNode) {
		LayoutManager.insertNewNumberInput(droppedNode)
		LayoutManager.insertNewNumberInput(droppedNode)
		LayoutManager.insertNewNumberOutput(droppedNode)
	}
}