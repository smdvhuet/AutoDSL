package info.scce.cinco.product.autoDSL.hooks

import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.Input
import info.scce.cinco.product.autoDSL.rule.rule.NonCommutableOperation
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.rule.rule.Output

//TODO Handling/preventing deletion of nodes in NonCommutableOperations. 
class LayoutManager {
	static val CONTAINER_PADDING_H = 5
	static val CONTAINER_PADDING_V = 6
	static val NODE_HEIGHT = 20
	
	static def rearrange(Operation op, IO io) {
		if( op.height == op.adjustedHeight ) {
			// Conversion occurred. Node not really new.
		} else {
			// Node added/removed.
			op.adjustHeight
			io.x = CONTAINER_PADDING_H
			switch io {
				Input : {
					op.shiftOutputs
					io.y = op.inputs.size * NODE_HEIGHT + CONTAINER_PADDING_V
					switch op {
						// In a NonCommutableOperation the first input is placed above the text. 
						NonCommutableOperation : if ( op.inputs.size == 1 ) io.y = io.y - NODE_HEIGHT
					}
				}
				Output : io.y = op.adjustedHeight - ( CONTAINER_PADDING_V + NODE_HEIGHT )
			}
		}
	}
	
	private static def adjustHeight(Operation op) {
		op.height = op.adjustedHeight
	} 
	
	private static def adjustedHeight(Operation op) {
		( 1 + op.inputs.size + op.outputs.size ) * NODE_HEIGHT + 2 * CONTAINER_PADDING_V 
	}

	private static def shiftOutputs(Operation op) {
		op.outputs.forEach[it.y = it.y + NODE_HEIGHT]
	}
	
	static def rearrangeAfterDelete(Operation op, IO io) {
		op.inputs.filter[it.y > io.y].forEach[it.y = it.y - NODE_HEIGHT]
		op.outputs.filter[it.y > io.y].forEach[it.y = it.y - NODE_HEIGHT]
		op.height = op.height - NODE_HEIGHT
	}
	
	static def prepareConversion(IO io) {
		val op = io.container as Operation
		op.inputs.filter[it.y > io.y].forEach[it.y = it.y + NODE_HEIGHT]
		op.outputs.filter[it.y > io.y].forEach[it.y = it.y + NODE_HEIGHT]
		op.height = op.height + NODE_HEIGHT
		io.delete
		op
	}
}