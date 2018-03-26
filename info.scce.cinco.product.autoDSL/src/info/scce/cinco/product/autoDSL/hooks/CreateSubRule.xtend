package info.scce.cinco.product.autoDSL.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubInput
import info.scce.cinco.product.autoDSL.rule.rule.BooleanSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.IO
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubInput
import info.scce.cinco.product.autoDSL.rule.rule.NumberSubOutput
import info.scce.cinco.product.autoDSL.rule.rule.SubRule
import org.eclipse.emf.common.util.BasicEList

class CreateSubRule extends CincoPostCreateHook<SubRule> {
	
	override postCreate(SubRule op) {
		val subRule = op.rule
		op.label = subRule.eResource.URI.lastSegment
		val ios = new BasicEList<IO>
		var toAdd = subRule.subRuleInputss.head?.inputs
		if( toAdd != null ) ios.addAll(toAdd)
		var alsoToAdd = subRule.subRuleOutputss.head?.outputs
		if( alsoToAdd != null ) ios.addAll(alsoToAdd)
		for( io : ios ){
			switch io {
				BooleanSubInput : op.newBooleanSubInput(0,0).identifier = io.identifier
				NumberSubInput : op.newNumberSubInput(0,0).identifier = io.identifier
				BooleanSubOutput : op.newBooleanSubOutput(0,0).identifier = io.identifier
				NumberSubOutput : op.newNumberSubOutput(0,0).identifier = io.identifier
			}
		}
	}
}