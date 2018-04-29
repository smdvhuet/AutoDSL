package info.scce.cinco.product.autoDSL.hooks;

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook;
import info.scce.cinco.product.autoDSL.autodsl.autodsl.ComponentNode;
import info.scce.cinco.product.autoDSL.rule.rule.Rule;

public class DropRuleHook extends CincoPostCreateHook<ComponentNode> {

	@Override
	public void postCreate(ComponentNode droppedNode) {
		Rule rule = droppedNode.getRule();
		String lastSegment = rule.eResource().getURI().lastSegment();
		droppedNode.setLabel(lastSegment.substring(0 ,lastSegment.lastIndexOf(".")));
	}

}
