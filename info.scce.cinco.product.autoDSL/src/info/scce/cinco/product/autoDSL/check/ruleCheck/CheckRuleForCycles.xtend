package info.scce.cinco.product.autoDSL.check.ruleCheck

import graphmodel.Container
import info.scce.cinco.product.autoDSL.rule.mcam.modules.checks.RuleCheck
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import java.util.HashMap
import info.scce.cinco.product.autoDSL.rule.rule.Output
import java.util.List
import java.util.ArrayList

class CheckRuleForCycles extends RuleCheck{
	
	override check(Rule rule) {
		val containers = rule.allContainers;
		var visited = new HashMap<Container, Boolean>();
		var finished = new HashMap<Container, Boolean>();
		for(container : containers){
			visited.put(container, false);
			finished.put(container, false);
		}
		val startContainer = containers.findFirst[x | x.getIncoming().size == 0];
		if(startContainer != null){
			if(!depthFirstSearchControlFlow(startContainer, visited, finished)){
					rule.addError("Cycle in control flow found")
					return;
			}
			if(!checkForDataFlowDependencyError(startContainer, new ArrayList<Output>(), startContainer)){
				
			}
		}
	}
	
	def boolean checkForDataFlowDependencyError(Container container, List<Output> list, Container startContainer){ //Liste wird mit Outputs aufgebaut, durch die bereits der Kontrollfluss gewandert ist
		val op = container as Operation;
		if(op.inputs.map[x | x.predecessors.map[y | y as Output]].flatten.findFirst[x | !list.contains(x)] != null){ //wenn die Eingaben für die Inputs noch nicht in der Liste sind, muss eine rekursive definition vorliegen
		
			op.addError("DependencyError in data flow found, a input uses data not yet calculated")
			return false;
		}
		list.addAll(op.outputs);
		val successors = container.getSuccessors().map[x | x as Container];
		for(successor: successors){
			if(!checkForDataFlowDependencyError(successor, list, startContainer)){
				return false;
			}
		}
		return true;
	}
	
	def boolean depthFirstSearchDataFlow(Container container, HashMap<Container, Boolean> visited, HashMap<Container, Boolean> finished){
		if(finished.get(container)){
			return true;
		}
		if(visited.get(container)){
			return false;
		}
		visited.put(container, true);
		val op = container as Operation; //all Containers are Operations
		val successorNodes = op.outputs.map[x | x.getSuccessors()].flatten;
		val containers = successorNodes.map[x | x.container].toSet.map[x | x as Operation];
		
		for(successorContainer : containers){
			if(!depthFirstSearchDataFlow(successorContainer, visited, finished)){
				return false;
			}
		}
		finished.put(container, true);
		return true;
	}
	
	def boolean depthFirstSearchControlFlow(Container container, HashMap<Container, Boolean> visited, HashMap<Container, Boolean> finished){
		if(finished.get(container)){
			return true;
		}
		if(visited.get(container)){
			return false;
		}
		visited.put(container, true);
		val successors = container.getSuccessors().map[x | x as Container];
		
		for(successorContainer : successors){
			if(!depthFirstSearchControlFlow(successorContainer, visited, finished)){
				return false;
			}
		}
		finished.put(container, true);
		return true;
	}
}