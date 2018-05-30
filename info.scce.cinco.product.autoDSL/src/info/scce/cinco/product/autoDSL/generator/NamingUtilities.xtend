package info.scce.cinco.product.autoDSL.generator

import java.security.InvalidParameterException
import info.scce.cinco.product.autoDSL.autodsl.autodsl.State
import java.util.HashMap
import info.scce.cinco.product.autoDSL.autodsl.autodsl.Guard
import info.scce.cinco.product.autoDSL.autodsl.autodsl.OffState
import org.eclipse.core.resources.IFolder
import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL
import org.eclipse.emf.common.util.URI
import info.scce.cinco.product.autoDSL.rule.rule.Rule

class NamingUtilities {
	public static def getOffStateVarName(OffState state, HashMap<Integer,String> knownOffStates){
		return getMemberVarName(state.id, "offstate", "", "_", knownOffStates)
	}
	
	public static def getStateVarName(State state, HashMap<Integer,String> knownStates){
		return getMemberVarName(state.id, state.label, "state", "_", knownStates)
	}
	
	public static def getGuardVarName(Guard guard, HashMap<Integer,String> knownGuards){
		return getMemberVarName(guard.id, guard.label, "guard", "_", knownGuards)
	}
	
	public static def getMemberVarName(String nativeId, String label, String prefix, String postfix, HashMap<Integer,String> knownNames){
		var id = IDHasher.GetIntHash(nativeId);
		var name = knownNames.get(id);
		
		if(name == null){
			//replace all spaces in the name
			var customLabel = label.replaceAll(" ", "_");
			
			name = toMemberVar(prefix + label + postfix);
			
			//try to use the user defined name. if it is already used add a counter to the name.
			var nameCount = 0;
			while(knownNames.containsValue(name)){
				nameCount++;
				name = toMemberVar(prefix + customLabel + nameCount + postfix);
			}
			                                                                              
			//safe the generated name 
			knownNames.put(id, name);
		}
		
		return name;		
	}
	
	public static def toMemberVar(String memberVarName){
		var output = memberVarName.trim();
		
		//Make letters after space uppercase
		var outputParts = output.split(" ")
		output = ""
		for(part : outputParts){
			output += part.substring(0, 1).toUpperCase() + part.substring(1)
		}
		
		output = output.replace(" ", "");
		
		if(!Character.isAlphabetic((output.charAt(0))))
			throw new InvalidParameterException("The member variable name must start with an letter.")
		
		//Convert upper case letters to lowercases with underscore before
		if(Character.isUpperCase(output.charAt(0))){
			if(output.length > 1)
				output = output.charAt(0).toString.toLowerCase + output.substring(1);
		}
		
		for(var int i = 1; i < output.length; i++){
			if(Character.isUpperCase(output.charAt(i))){
				if(output.charAt(i - 1) != '_'){
					output = output.substring(0, i) + "_" + output.charAt(i).toString().toLowerCase() + output.substring(i + 1);
				}else{
					output = output.substring(0, i) + output.charAt(i).toString().toLowerCase() + output.substring(i + 1);
				}
			}
		}
		
		//End on underscore
		if(!output.endsWith("_")){
			output += "_";
		}
		
		return output;
	}
	
	
	
	public static def getTypeName(AutoDSL dsl, HashMap<Integer,String> knownDSLTypes, IFolder rootFolder){
	  return getTypeName(dsl.id, dsl.eResource().getURI(), ".autodsl", knownDSLTypes, rootFolder)
	}
	
	public static def getTypeName(Rule rule, HashMap<Integer,String> knownRuleTypes, IFolder rootFolder){
	  return getTypeName(rule.id, rule.eResource().getURI(), ".rule", knownRuleTypes, rootFolder)
	}
	
	public static def getTypeName(String nativeId, URI resourcePath, String typeExtension, HashMap<Integer,String> knownTypeNames, IFolder rootFolder){
	  var id = 	IDHasher.GetIntHash(nativeId);
	  var name = knownTypeNames.get(id);
	  
	  if(name == null){
	  	var String[] names = resourcePath.lastSegment().split(typeExtension).get(0).split("_")
	  	
	  	name = getPrefix(resourcePath.path, rootFolder);
	  	for(String n : names) {
	  		name = name + n.toFirstUpper
	  	}
	  	
	  	//safe the dsltype name
	  	knownTypeNames.put(IDHasher.GetIntHash(name), name)
	  }
		
	  return name;		
	}
	
	public static  def getPrefix(String filePath, IFolder rootFolder){
		var projectName = rootFolder.project.name;
		var projectRelativeFilePath = filePath.substring(filePath.indexOf(projectName) + projectName.length + 1, filePath.length);
		var folders = projectRelativeFilePath.split("/");
		
		var prefix = "";
		for(var i = 0; i < folders.length - 1; i++){
			prefix += folders.get(i).toFirstUpper();
		}
		
		return prefix;
	}
}