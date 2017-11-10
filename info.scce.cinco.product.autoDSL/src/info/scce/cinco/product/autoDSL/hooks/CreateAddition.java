package info.scce.cinco.product.autoDSL.hooks;

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook;
import info.scce.cinco.product.autoDSL.rule.rule.Addition;

public class CreateAddition extends CincoPostCreateHook<Addition> {

	@Override
	public void postCreate(Addition droppedNode) {
		droppedNode.newPrimitiveInputPort(4, 24).setName("a");
		droppedNode.newPrimitiveInputPort(4, 24+18).setName("b");
	}

}
