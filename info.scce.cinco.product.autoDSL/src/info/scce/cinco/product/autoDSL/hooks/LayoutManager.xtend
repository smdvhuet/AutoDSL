package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.*
import graphmodel.Node

class LayoutManager {
	static val NODE_MARGIN_LEFT = 5;
	static val NODE_MARGIN_TOP = 26; // header height
	static val PORT_HEIGHT = 20;
	
	// Only works for commutable operations so far
	static def insertBooleanInput(Operation target) {
		val inputs = target.existingInputs
		val max = if (!inputs.isEmpty()) inputs.max[Node a, Node b | a.y - b.y] else null
		val highestY = if (max != null) max.y else NODE_MARGIN_TOP - PORT_HEIGHT
		if (highestY + PORT_HEIGHT > target.height) {
			target.height = target.height + PORT_HEIGHT;
		}
		target.newBooleanInputPort(NODE_MARGIN_LEFT, highestY + PORT_HEIGHT)
		target.shiftOutputs
	}

	static def insertNumberInput(Operation target) {
		val inputs = target.existingInputs
		val max = if (!inputs.isEmpty()) inputs.max[Node a, Node b | a.y - b.y] else null
		val highestY = if (max != null) max.y else NODE_MARGIN_TOP - PORT_HEIGHT
		if (highestY + PORT_HEIGHT > target.height) {
			target.height = target.height + PORT_HEIGHT;
		}
		target.newNumberInputPort(NODE_MARGIN_LEFT, highestY + PORT_HEIGHT)
		target.shiftOutputs
	}

	static def insertBooleanOutput(Operation target) {
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
		target.newBooleanOutputPort(NODE_MARGIN_LEFT, highestY + PORT_HEIGHT)
	}

	static def insertNumberOutput(Operation target) {
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
		target.newNumberOutputPort(NODE_MARGIN_LEFT, highestY + PORT_HEIGHT)
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

	private static def newBooleanInputPort(Operation op, int x, int y) {
		if (op instanceof CommutableOperation) {
			(op as CommutableOperation).newBooleanInputPort(x, y);
		} else if (op instanceof NonCommutableOperation) {
			(op as NonCommutableOperation).newBooleanInputPort(x, y);
		} else {
			throw new IllegalArgumentException("Unknown Operation subclass")
		}
	}

	private static def newNumberInputPort(Operation op, int x, int y) {
		if (op instanceof CommutableOperation) {
			(op as CommutableOperation).newNumberInputPort(x, y);
		} else if (op instanceof NonCommutableOperation) {
			(op as NonCommutableOperation).newNumberInputPort(x, y);
		} else {
			throw new IllegalArgumentException("Unknown Operation subclass")
		}
	}

	private static def newBooleanOutputPort(Operation op, int x, int y) {
		if (op instanceof CommutableOperation) {
			(op as CommutableOperation).newBooleanOutputPort(x, y);
		} else if (op instanceof NonCommutableOperation) {
			(op as NonCommutableOperation).newBooleanOutputPort(x, y);
		} else {
			throw new IllegalArgumentException("Unknown Operation subclass")
		}
	}

	private static def newNumberOutputPort(Operation op, int x, int y) {
		if (op instanceof CommutableOperation) {
			(op as CommutableOperation).newNumberOutputPort(x, y);
		} else if (op instanceof NonCommutableOperation) {
			(op as NonCommutableOperation).newNumberOutputPort(x, y);
		} else {
			throw new IllegalArgumentException("Unknown Operation subclass")
		}
	}
}