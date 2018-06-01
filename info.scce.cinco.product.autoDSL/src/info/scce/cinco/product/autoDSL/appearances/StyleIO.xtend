package info.scce.cinco.product.autoDSL.appearances

import de.jabc.cinco.meta.core.ge.style.generator.runtime.appearance.StyleAppearanceProvider
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubCarInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.NumberInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubCarInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubStaticInput
import style.StyleFactory

class StyleIO implements StyleAppearanceProvider<IO> {

	override getAppearance(IO io, String element) {
		val app = StyleFactory.eINSTANCE.createAppearance
		switch io {
			BooleanStaticInput, NumberStaticInput, BooleanSubStaticInput, NumberSubStaticInput : app.imagePath = "icons/StaticInput.png"
			BooleanCarInput, NumberCarInput, BooleanSubCarInput, NumberSubCarInput : app.imagePath = "icons/CarInput.png"
			BooleanInputPort, NumberInputPort, BooleanSubInputPort, NumberSubInputPort : app.imagePath = "icons/inputPort.png"
			BooleanCarOutput, NumberCarOutput : app.imagePath = "icons/CarOutput.png"
			BooleanOutputPort, NumberOutputPort, BooleanSubOutputPort, NumberSubOutputPort : app.imagePath = "icons/outputPort.png"
		}
		app
	}
	
}