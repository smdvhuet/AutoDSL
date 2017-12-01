package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class CreateComparison extends CincoPostCreateHook<Operation> {
	
	override  postCreate(Operation droppedNode) {
		droppedNode.newNumberInputPort(5, 6)
		droppedNode.newNumberInputPort(5, 46)
		LayoutManager.insertNewBooleanOutput(droppedNode)
	}
}