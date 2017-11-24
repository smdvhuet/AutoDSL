package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.NonCommutableOperation
import info.scce.cinco.product.autoDSL.rule.rule.PrimitiveType

class CreateSubtraction extends CincoPostCreateHook<NonCommutableOperation> {
	
	override  postCreate(NonCommutableOperation droppedNode) {
		droppedNode.newInputPort(5, 6).setDatatype(PrimitiveType.NUMBER)
		droppedNode.newInputPort(5, 46).setDatatype(PrimitiveType.NUMBER)
		var difference = droppedNode.newOutputPort(6, 66)
		difference.setDatatype(PrimitiveType.NUMBER)
	}
}