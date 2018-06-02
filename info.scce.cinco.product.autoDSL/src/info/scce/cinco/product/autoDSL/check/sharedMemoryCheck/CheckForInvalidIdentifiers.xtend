package info.scce.cinco.product.autoDSL.check.sharedMemoryCheck

import info.scce.cinco.product.autoDSL.sharedMemory.mcam.modules.checks.SharedMemoryCheck
import info.scce.cinco.product.autoDSL.sharedMemory.sharedmemory.SharedMemory
import info.scce.cinco.product.autoDSL.sharedMemory.sharedmemory.StoredData

class CheckForInvalidIdentifiers extends SharedMemoryCheck {

	override check(SharedMemory model) {
		val listOfNames = model.storedDatas.map[it.label]
		model.storedDatas.forEach[
			val currentNode = it //Store for later use in nested for/filter stuff
			if(currentNode.label == null || currentNode.label.isEmpty) {
				currentNode.addError("Missing or empty label.")
			}
			else if(listOfNames.filter[it == currentNode.label].size > 1){
				currentNode.addError("Duplicate label '" + currentNode.label.toString + "' found. Please make sure labels are unique.")
			}
			else {
				CheckXtextIdentifierUsage(currentNode)
			}
		]
	}
	
	def CheckXtextIdentifierUsage(StoredData node){
		//Checks if node.label is a valid xtext identifier to make sure it can be used in TestDSL without errors
		val identifier = node.label
		if(Character.isDigit(identifier.charAt(0))){
			node.addError("Labels may not begin with numbers")
		}
		else if (identifier.contains(" ")){
			node.addError("Labels may not contain any spaces")
		}
	}
}
