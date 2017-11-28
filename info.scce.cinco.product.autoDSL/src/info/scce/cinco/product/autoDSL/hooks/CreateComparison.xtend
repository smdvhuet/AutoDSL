package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.NonCommutableOperation

class CreateComparison extends CincoPostCreateHook<NonCommutableOperation> {
	
	override  postCreate(NonCommutableOperation droppedNode) {
		droppedNode.newNumberInputPort(5, 6)
		droppedNode.newNumberInputPort(5, 46)
		droppedNode.newBooleanOutputPort(6, 66)
	}
}