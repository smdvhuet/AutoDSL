package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.Operation

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

abstract class IOConversion extends CincoCustomAction<IO> {
	
	protected int x
	protected int y
	protected Operation op
	def memorize(IO io){
		x = io.x
		y = io.y
		op = io.operation
	}
	
//	def restore(IO io){
//	}
	
	override getName() {
		"Covert to " + targetType
	}
	
	override execute(IO io) {
		io.memorize
		LayoutManager.prepareConversion(io)
		io.createConversionTarget
	}
	
	override canExecute(IO io){
		io.memorize
//		io.delete
//TODO delete io without causing problems to check if the desired replacement can be created (without the deletion the result will be false too many times!)
//		val p = io.canCreateConversionTarget
//TODO restore io in case the desired replacement cannot be created
//		if(!p){
//			io.restore
//		}
//		p
//TODO do not always return true! This results in the deletion of IO nodes wrongly forced to be converted right now
		super.canExecute(io)
	}

	def String targetType()	
	def void createConversionTarget(IO io)
	def boolean canCreateConversionTarget(IO io)
}