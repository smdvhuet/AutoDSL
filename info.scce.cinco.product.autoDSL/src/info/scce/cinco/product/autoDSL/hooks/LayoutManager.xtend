package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.xapi.WorkbenchExtension
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.Input
import info.scce.cinco.product.autoDSL.rule.rule.NonCommutableOperation
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.rule.rule.Output
import info.scce.cinco.product.autoDSL.rule.rule.PIDController
import info.scce.cinco.product.autoDSL.rule.rule.StoredPIDController

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class LayoutManager {
	/**
	 * Padding (top, right, bottom, left) of containers.
	 */
	static val CONTAINER_PADDING = 5
	/**
	 * Height of IO nodes, as well as texts in containers (e.g. operation symbols).
	 * Includes one additional pixel as separator for convenience. 
	 */
	static val NODE_HEIGHT = 21
	
	/**
	 * Places newly created IO node within Operation container, adjusting the latter's height if necessary.
	 */
	static def rearrangePostCreate(IO io) {
		val op = io.operation
		io.placeHorizontally
		if( op.height < op.adjustedHeight ) {
			op.adjustHeight
			io.placeVertically
			switch io {
				Input : op.outputs.shift(NODE_HEIGHT)
			}
		} else {
			// Either a conversion occurred (Node not really new, no actions necessary.)
			// Or a node has been created within a NonCommutableOperation after its deletion.
			switch op {
				NonCommutableOperation case ( op.inputs.findFirst[!it.equals(io)]?.y != io.y + 2 * NODE_HEIGHT ) : io.placeVertically
			}
		}
	}
	
	private static def placeHorizontally (IO io) {
		io.x = CONTAINER_PADDING
	}
	
	private static def isFirstInput (IO io) {
		switch io {
			Input : io.operation.inputs.size == 1
			default : false
		}
	}
	
	private static def placeVertically (IO io) {
		val op = io.operation
		var verticalPlacement = op.inputs.size * NODE_HEIGHT + CONTAINER_PADDING
		switch io {
			Output : verticalPlacement += op.outputs.size * NODE_HEIGHT
		}
		switch op {
			PIDController : verticalPlacement += 3 * NODE_HEIGHT
			StoredPIDController : verticalPlacement += 3 * NODE_HEIGHT
			// In a NonCommutableOperation the first input is placed above the text. 
			NonCommutableOperation case io.isFirstInput : verticalPlacement -= NODE_HEIGHT
		}
		io.y = verticalPlacement
	}
	
	private static def adjustHeight(Operation op) {
		op.height = op.adjustedHeight
	} 
	
	private static def adjustedHeight(Operation op) {
		var adjusted = ( 1 + op.inputs.size + op.outputs.size ) * NODE_HEIGHT + 2 * CONTAINER_PADDING - 1 
		switch op {
			PIDController : adjusted += 3 * NODE_HEIGHT
			StoredPIDController : adjusted += 3 * NODE_HEIGHT
		}
		adjusted
	}
	
	private static def <T extends IO> shift(Iterable<T> io, int amount) {
		io.forEach[it.y = it.y + amount]
	}
	
	private static def rearrangePreDelete(IO io, int amount) {
		val op = io.operation
		op.inputs.filter[it.y > io.y].shift(amount)
		switch op {
			// In a NonCommutableOperation the first input is placed above the text. 
			NonCommutableOperation : op.inputs.filter[it.y > io.y].shift(amount)
			default : {
				op.outputs.filter[it.y > io.y].shift(amount)
				op.height = op.height + amount
			}
		}
	}
	
	static def rearrangePreDelete(IO io) {
		rearrangePreDelete(io, -NODE_HEIGHT)
	}
	
	/**
	 * @param io The IO node which is to be converted 
	 */
	static def prepareConversion(IO io) {
		rearrangePreDelete(io, NODE_HEIGHT)
		io.delete
	}
	
	static def resizeOperation(Operation op, int newWidth) {
		op.adjustHeight
		/* Setting the new size deliberately twice to prevent display errors!
		 * Interior components are distributed more or less randomly otherwise. (bug?)
		 */
		for(var i = 0; i < 2; i++) {
			op.inputs.resizeIO(newWidth)
			op.outputs.resizeIO(newWidth)
		}
	}
	
	private static def <T extends IO> resizeIO(Iterable<T> ios, int newWidth) {
		for(io : ios){
			//Checking whether a pictogramElement is already present
			extension val WorkbenchExtension = new WorkbenchExtension
			if(io.pictogramElement != null){
				io.width = newWidth - 2 * CONTAINER_PADDING
			}
		}
	}
	
}