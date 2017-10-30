package info.scce.cinco.product.autoDSL.hooks;

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook;
import info.scce.cinco.product.autoDSL.autodsl.autodsl.ComponentNode;
import info.scce.cinco.product.autoDSL.rule.rule.Rule;

public class DropRuleHook extends CincoPostCreateHook<ComponentNode> {

	@Override
	public void postCreate(ComponentNode droppedNode) {
		Rule rule = droppedNode.getRule();
		droppedNode.setLabel(rule.eResource().getURI().lastSegment());
		/*List<Start> l = droppedNode.getRule().getStarts();
		if (!l.isEmpty()) {
			System.out.println("Dropped node has outgoing edges: " + l.get(0).getOutgoing());
		} else {
			System.out.println("Dropped node contains no Start!");
		}*/
	}

}
