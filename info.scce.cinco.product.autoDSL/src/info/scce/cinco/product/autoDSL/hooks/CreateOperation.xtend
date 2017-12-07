package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.Operation

class CreateOperation extends CincoPostCreateHook<Operation> {
	
	override postCreate(Operation op) {
		for(var i = 0; i < 2; i++) {
			switch op {
				case op.canNewBooleanInputPort : op.newBooleanInputPort(0,0)
				case op.canNewNumberInputPort : op.newNumberInputPort(0,0) 
			}
		}
		switch op {
			case op.canNewBooleanOutputPort : op.newBooleanOutputPort(0,0)
			case op.canNewNumberOutputPort : op.newNumberOutputPort(0,0)
			case op.canNewBooleanCarOutput : op.newBooleanCarOutput(0,0)
			case op.canNewNumberCarOutput : op.newNumberCarOutput(0,0)
		}
	}
}