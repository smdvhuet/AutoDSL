package info.scce.cinco.product.autoDSL.generator.autodslGenerator

import java.util.HashMap;

class IDHasher {
	static HashMap<String, Integer> stringHash2IdHash = new HashMap<String, Integer>();	
	
	//Get an integer hash instead of the passed string hash. All integer values are non negativ.
	public static def Integer GetIntHash(String stringHash){
		var value = stringHash2IdHash.get(stringHash);
		
		if(value == null){
			value = stringHash2IdHash.size();
			stringHash2IdHash.put(stringHash, value); 
		}
		
		return value;
	}
	
	public static def String GetStringHash(String stringHash){
		return "_" + GetIntHash(stringHash).toString();
	}
	
	public static def Clear(){
		stringHash2IdHash.clear();
	}
	
	public static def boolean Contains(String stringHash){
		return stringHash2IdHash.containsKey(stringHash);
	}
}