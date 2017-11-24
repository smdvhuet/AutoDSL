package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.tmprule.tmprule.PrimitiveType
import info.scce.cinco.product.autoDSL.tmprule.tmprule.CommutableOperation

class CreateCommutableNumberOp extends CincoPostCreateHook<CommutableOperation> {
	
	override  postCreate(CommutableOperation droppedNode) {
		LayoutManager.insertInput(droppedNode, PrimitiveType.NUMBER)
		LayoutManager.insertInput(droppedNode, PrimitiveType.NUMBER)
		LayoutManager.insertOutput(droppedNode, PrimitiveType.NUMBER)
	}
}