package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.*
import graphmodel.Node

class LayoutManager {
	static val NODE_MARGIN_LEFT = 5;
	static val NODE_MARGIN_TOP = 26; // header height
	static val PORT_HEIGHT = 20;
	
	// Only works for commutable operations so far
	static def insertInput(Operation target) {
		val inputs = target.existingInputs
		val max = if (!inputs.isEmpty()) inputs.max[Node a, Node b | a.y - b.y] else null
		val highestY = if (max != null) max.y else NODE_MARGIN_TOP - PORT_HEIGHT
		if (highestY + PORT_HEIGHT > target.height) {
			target.height = target.height + PORT_HEIGHT;
		}
		target.newInputPort(NODE_MARGIN_LEFT, highestY + PORT_HEIGHT)
		target.shiftOutputs
	}

	static def insertOutput(Operation target) {
		val outputs = target.existingOutputs;
		var max = if (!outputs.isEmpty()) outputs.max[Node a, Node b | a.y - b.y] as Node else null
		if (max == null) {
			val inputs = target.existingInputs
			max = if (!inputs.isEmpty()) inputs.max[Node a, Node b | a.y - b.y] else null
		}
		val highestY = if (max != null) max.y else NODE_MARGIN_TOP - PORT_HEIGHT
		if (highestY + PORT_HEIGHT > target.height) {
			target.height = target.height + PORT_HEIGHT;
		}
		target.newOutputPort(NODE_MARGIN_LEFT, highestY + PORT_HEIGHT)
	}

	private static def shiftOutputs(Operation op) {
		op.existingOutputs.forEach[it.y = it.y + PORT_HEIGHT]
	}

	/* Wrappers that consolidate Operation descendants */
	private static def getExistingInputs(Operation op) {
		if (op instanceof CommutableOperation) {
			(op as CommutableOperation).inputs;
		} else if (op instanceof NonCommutableOperation) {
			(op as NonCommutableOperation).inputs;
		} else {
			throw new IllegalArgumentException("Unknown Operation subclass")
		}
	}

	private static def getExistingOutputs(Operation op) {
		if (op instanceof CommutableOperation) {
			(op as CommutableOperation).outputs;
		} else if (op instanceof NonCommutableOperation) {
			(op as NonCommutableOperation).outputs;
		} else {
			throw new IllegalArgumentException("Unknown Operation subclass")
		}
	}

	private static def newInputPort(Operation op, int x, int y) {
		if (op instanceof CommutableOperation) {
			(op as CommutableOperation).newInputPort(x, y);
		} else if (op instanceof NonCommutableOperation) {
			(op as NonCommutableOperation).newInputPort(x, y);
		} else {
			throw new IllegalArgumentException("Unknown Operation subclass")
		}
	}

	private static def newOutputPort(Operation op, int x, int y) {
		if (op instanceof CommutableOperation) {
			(op as CommutableOperation).newOutputPort(x, y);
		} else if (op instanceof NonCommutableOperation) {
			(op as NonCommutableOperation).newOutputPort(x, y);
		} else {
			throw new IllegalArgumentException("Unknown Operation subclass")
		}
	}
}