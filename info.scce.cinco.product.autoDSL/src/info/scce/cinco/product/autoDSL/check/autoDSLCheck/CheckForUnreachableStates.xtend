package info.scce.cinco.product.autoDSL.check.autoDSLCheck

import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL
import info.scce.cinco.product.autoDSL.autodsl.mcam.modules.checks.AutoDSLCheck
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.autodsl.autodsl.State
import java.util.HashMap
import java.util.ArrayList

class CheckForUnreachableStates extends AutoDSLCheck{
	
	override check(AutoDSL model) {
		model.addWarning("Check not implemented yet, model may contain unreachable states")
		val start = model.offStates.head
		var completed = new HashMap<State, Boolean>()
		for(state : model.states)
			completed.put(state, false)
		val todo = new ArrayList<State>()
		for(guard : start.guardSuccessors){
			for (state : guard.stateSuccessors){
				todo.add(state)
			}
		}
		//Main Loop
		while(!todo.empty){
			val current = todo.get(0)
			if(!completed.get(current)){
				for(guard : start.guardSuccessors){
					for (state : guard.stateSuccessors){
						if((!(completed.get(state))) && (!(todo.contains(state))))
							todo.add(state)
					}
				}	
				completed.put(current, true)
			}
			todo.remove(0)
		}
		
		//Check results
		for(state : model.states)
			if(!completed.get(state))
				state.addError("State not reachable from Off-State")
	}
	
}