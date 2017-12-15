package info.scce.cinco.product.autoDSL.appearances

import de.jabc.cinco.meta.core.ge.style.generator.runtime.appearance.StyleAppearanceProvider
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.NumberInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberStaticInput
import style.StyleFactory

class StyleIO implements StyleAppearanceProvider<IO> {

	override getAppearance(IO io, String element) {
		val app = StyleFactory.eINSTANCE.createAppearance
		//TODO wait until app.imagePath is fixed (works just fine under Cinco 0.7)
		switch io {
			BooleanStaticInput, NumberStaticInput : app.imagePath = "icons/StaticInput.png"
			BooleanCarInput, NumberCarInput : app.imagePath = "icons/CarInput.png"
			BooleanInputPort, NumberInputPort : app.imagePath = "icons/inputPort.png"
			BooleanCarOutput, NumberCarOutput : app.imagePath = "icons/CarOutput.png"
			BooleanOutputPort, NumberOutputPort : app.imagePath = "icons/outputPort.png"
		}
		app
	}
	
}