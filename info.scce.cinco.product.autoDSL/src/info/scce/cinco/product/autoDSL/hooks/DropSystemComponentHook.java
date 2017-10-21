package info.scce.cinco.product.autoDSL.hooks;

import java.util.List;

import info.scce.cinco.product.autoDSL.autodsl.autodsl.ComponentNode;
import info.scce.cinco.product.autoDSL.systemcomponent.systemcomponent.SomeNodeComp;
import de.jabc.cinco.meta.core.ge.style.model.customfeature.CincoPostCreateHook;

public class DropSystemComponentHook extends CincoPostCreateHook<ComponentNode> {

	@Override
	public void postCreate(ComponentNode droppedNode) {
		List<SomeNodeComp> l = droppedNode.getSyscomp().getSomeNodeComps();
		if (!l.isEmpty()) {
			System.out.println("Dropped node contains: " + l.get(0).getLabel());
		} else {
			System.out.println("Dropped node contains no elements!");
		}
	}

}
