package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.*
import graphmodel.Node
import java.awt.Point

class LayoutManager {
	static val NODE_MARGIN_LEFT = 5;
	static val NODE_MARGIN_TOP = 26; // header height
	static val PORT_HEIGHT = 20;
	
	/**
	 * Increases the height of an Operation node (if necessary) and
	 * calculates coordinates for a new input.
	 * @param target Operation into which the Input shall be inserted
	 * @param newInput The Input object to be inserted (only needs to be passed if it already exists and needs to be filtered)
	 * @return Point object with coordinates
	 */
	static def prepareInputInsertion(Operation target, Input newInput) {
		var highestInputY = 0;
		if (target instanceof CommutableOperation) {
			// Must not factor newInput dropped by user into calculation (it could be at any position right now)
			val max = ymax(target.inputs.filter[it != newInput])
			highestInputY = if (max != null) max.y else NODE_MARGIN_TOP - PORT_HEIGHT
			val maxOut = ymax(target.outputs)
			if ((if (maxOut != null) maxOut.y else highestInputY) + PORT_HEIGHT*2 > target.height) {
				target.height = target.height + PORT_HEIGHT;
			}
		} else if (target instanceof NonCommutableOperation) {
			val inp = target.inputs
			if (inp.size() == 1) {
				highestInputY = NODE_MARGIN_TOP - PORT_HEIGHT*2;
			} else if (inp.size() == 2) {
				highestInputY = NODE_MARGIN_TOP;
			} else
				throw new IllegalStateException("NonCommutable has too many inputs")
		} else {
			return null // no auto-positioning supported
		}
		new Point(NODE_MARGIN_LEFT, highestInputY + PORT_HEIGHT)
	}

	/**
	 * Increases the height of an Operation node (if necessary) and
	 * calculates coordinates for a new output.
	 * @param target Operation into which the Output shall be inserted
	 * @return Point object with coordinates
	 */
	static def prepareOutputInsertion(Operation target) {
		var max = ymax(target.outputs)
		if (max == null) {
			// No outputs yet, get highest input instead
			max = ymax(target.inputs)
		}
		val highestY = if (max != null) max.y else NODE_MARGIN_TOP - PORT_HEIGHT
		if (highestY + PORT_HEIGHT > target.height) {
			target.height = target.height + PORT_HEIGHT;
		}
		new Point(NODE_MARGIN_LEFT, highestY + PORT_HEIGHT)
	}
	
	static def insertNewBooleanInput(Operation target) {
		target.newBooleanInputPort(0,0) // create hook will call insertInput
	}

	static def insertNewNumberInput(Operation target) {
		target.newNumberInputPort(0,0) // create hook will call insertInput
	}

	static def insertNewBooleanOutput(Operation target) {
		val pt = prepareOutputInsertion(target)
		target.newBooleanOutputPort(pt.x, pt.y)
	}

	static def insertNewNumberOutput(Operation target) {
		val pt = prepareOutputInsertion(target)
		target.newNumberOutputPort(pt.x, pt.y)
	}
	
	static def insertInput(Operation target, Input input) {
		val pt = prepareInputInsertion(target, input)
		if (pt != null) {
			input.move(pt.x, pt.y)
			target.shiftOutputs
		}
	}

	static def insertOutput(Operation target, Input input) {
		val pt = prepareOutputInsertion(target)
		input.move(pt.x, pt.y)
	}
	
	static def deleteInput(Operation target, Input input) {
		val affectedPorts = target.inputs.filter[it.y > input.y];
		affectedPorts.forEach[ element, index | element.move(element.x, element.y - PORT_HEIGHT)]
		target.outputs.forEach[element, index | element.move(element.x, element.y - PORT_HEIGHT)]
		target.height = target.height - PORT_HEIGHT
	}

	private static def shiftOutputs(Operation op) {
		op.outputs.forEach[it.y = it.y + PORT_HEIGHT]
	}

	/**
	 * Returns the Node with the highest Y value in l or null if the list is empty.
	 */
	private static def ymax(Iterable<? extends Node> l) {
		if (l.isEmpty()) null else l.max[Node a, Node b | a.y - b.y]
	}
}