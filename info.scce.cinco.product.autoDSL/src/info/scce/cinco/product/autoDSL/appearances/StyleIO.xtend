package info.scce.cinco.product.autoDSL.appearances

import de.jabc.cinco.meta.core.ge.style.generator.runtime.appearance.StyleAppearanceProvider
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanCarOutput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanProgrammableNodeCarInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanProgrammableNodeInputPort
import info.scce.cinco.product.autoDSL.rule.rule.BooleanProgrammableNodeStaticInput
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
import info.scce.cinco.product.autoDSL.rule.rule.NumberProgrammableNodeCarInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberProgrammableNodeInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberProgrammableNodeStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubCarInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutputPort
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubStaticInput
import style.StyleFactory

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class StyleIO implements StyleAppearanceProvider<IO> {

	override getAppearance(IO io, String element) {
		val app = StyleFactory.eINSTANCE.createAppearance
		switch io {
			BooleanCarInput, NumberCarInput, BooleanSubCarInput, NumberSubCarInput,
			BooleanProgrammableNodeCarInput, NumberProgrammableNodeCarInput : app.imagePath = "icons/CarInput.png"
			BooleanInputPort, NumberInputPort, BooleanSubInputPort, NumberSubInputPort,
			BooleanProgrammableNodeInputPort, NumberProgrammableNodeInputPort : app.imagePath = "icons/inputPort.png"
			BooleanStaticInput, NumberStaticInput, BooleanSubStaticInput, NumberSubStaticInput,
			BooleanProgrammableNodeStaticInput, NumberProgrammableNodeStaticInput : app.imagePath = "icons/StaticInput.png"
			BooleanCarOutput, NumberCarOutput : app.imagePath = "icons/CarOutput.png"
			BooleanOutputPort, NumberOutputPort, BooleanSubOutputPort, NumberSubOutputPort : app.imagePath = "icons/outputPort.png"
		}
		if(!"label".equals(element)){
			app.background = createColor(255,255,255)
			app.foreground = createColor(255,255,255)
		}
		if(io.isProgrammableNode){
			app.background = createColor(100,100,100)
			app.lineInVisible = true
			if("label".equals(element)) {
				app.foreground = createColor(255,255,255)
			}
		}   
		app
	}
	
	def createColor(int r, int g, int b){
		val color = StyleFactory.eINSTANCE.createColor 
		color.r = r
		color.g = g
		color.b = b
		color
	}
}