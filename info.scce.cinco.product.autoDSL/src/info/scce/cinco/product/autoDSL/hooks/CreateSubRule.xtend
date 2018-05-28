package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.SubRule
import org.eclipse.emf.common.util.BasicEList

import static extension info.scce.cinco.product.autoDSL.extensions.IOExtension.*

class CreateSubRule extends CincoPostCreateHook<SubRule> {
	
	override postCreate(SubRule op) {
		val subRule = op.rule
		op.label = subRule.eResource.URI.lastSegment
		val ios = new BasicEList<IO>
		var toAdd = subRule.subRuleInputss.head?.outputs
		if( toAdd != null ) ios.addAll(toAdd)
		var alsoToAdd = subRule.subRuleOutputss.head?.inputs
		if( alsoToAdd != null ) ios.addAll(alsoToAdd)
		for( io : ios ){
			op.createNewOfSameType(io).identifier = io.identifier
		}
	}
}