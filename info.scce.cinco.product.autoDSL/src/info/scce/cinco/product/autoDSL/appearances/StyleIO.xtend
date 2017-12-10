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
		//For demonstration only, no real use
		val color = StyleFactory.eINSTANCE.createColor
		var pos = io.y
		if (pos > 255) pos = 255
		color.r = pos
		color.g = pos
		color.b = pos
		app.lineInVisible = true
		app.foreground = color
		//TODO get app.imagePath to work
		switch io {
			BooleanStaticInput, NumberStaticInput : app.imagePath = "icons/StaticInput.png"
			BooleanCarInput, NumberCarInput : app.imagePath = "icons/CarInput.png"
			BooleanInputPort, NumberInputPort : app.imagePath = "icons/inputPort.png"
			BooleanCarOutput, NumberCarOutput : app.imagePath = "icons/CarOutput.png"
			BooleanOutputPort, NumberOutputPort : app.imagePath = "icons/outputPort.png"
		}
//		Possible, but ugly and non-consistent access:
//		val cs = io.class.methods.findFirst[it.returnType.equals(ContainerShape)].invoke(io) as ContainerShape
//		val img = cs.children.findFirst[it.graphicsAlgorithm instanceof Image].graphicsAlgorithm as Image
//		img.id = "icons/StaticInput.png"
		app
	}
	
}