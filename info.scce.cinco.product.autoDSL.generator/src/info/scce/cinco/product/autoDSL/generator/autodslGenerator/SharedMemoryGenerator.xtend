package info.scce.cinco.product.autoDSL.generator.autodslGenerator

import info.scce.cinco.product.autoDSL.sharedMemory.sharedmemory.SharedMemory
import java.util.ArrayList
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IFolder
import de.jabc.cinco.meta.core.utils.projects.ProjectCreator
import de.jabc.cinco.meta.core.utils.EclipseFileUtils
import java.util.HashMap

class SharedMemoryGenerator{
	
	static var HashMap<Integer, String> knownMemory =  new HashMap<Integer, String>()
	public static var HashMap<String,String> externSharedMemoryVars = new HashMap<String, String>()
	
	def generate(SharedMemory memory) {
		if(!knownMemory.containsKey(IDHasher.GetIntHash(memory.id))){
			val ArrayList<String> srcFolders = new ArrayList<String>()
			srcFolders.add("src-gen")
			
			val IProject project = ProjectCreator.getProject(memory.eResource)
			var IFolder mainFolder = project.getFolder("src-gen")
			EclipseFileUtils.writeToFile(mainFolder.getFile(memory.memoryName+".h"), generateStruct(memory))
			EclipseFileUtils.writeToFile(mainFolder.getFile(memory.memoryName+".cpp"), generateCPP(memory))
			
			
		}
		return memory.memoryName
	}
	
//*********************************************************************************
//							generating Header
//*********************************************************************************
	def generateStruct(SharedMemory memory)'''
	#ifndef AUTODSL_«memory.memoryName.toUpperCase»_H_
	#define AUTODSL_«memory.memoryName.toUpperCase»_H_
	
	#include "core/PID.h"
	namespace AutoDSL{
		struct «memory.memoryName»{
			//bools
			«FOR bool:memory.storedBooleans»
			bool «bool.label» = «bool.defaultValue»;
			«if (externSharedMemoryVars.get(memory.memoryName + "." + bool.label) == null){ externSharedMemoryVars.put(memory.memoryName + "." + bool.label, "g" + memory.memoryName + "_var." + bool.label); }»
			«ENDFOR»
			
			//numbers
			«FOR number:memory.storedNumbers»
			double «number.label» = «number.defaultValue»;
			«if (externSharedMemoryVars.get(memory.memoryName + "." + number.label) == null){ externSharedMemoryVars.put(memory.memoryName + "." + number.label, "g" + memory.memoryName + "_var." + number.label); }»
			«ENDFOR»
			
			//PIDs
			«FOR pid:memory.storedPIDControllers»
			ACCPlusPlus::PID «pid.label»{«pid.p»,«pid.i»,«pid.d»};
			«ENDFOR»
		};
		extern «memory.memoryName» g«memory.memoryName»_var;
	} //namespace AutoDSL
	#endif
	'''
//*********************************************************************************
//						generating global Variable
//*********************************************************************************
	def generateCPP(SharedMemory memory)'''
	#include "«memory.memoryName».h"
	namespace AutoDSL{
		«memory.memoryName» g«memory.memoryName»_var;
	} //namespace AutoDSL
	'''
	
	def static getMemoryName(SharedMemory memory){
	  var id = 	IDHasher.GetIntHash(memory.id)
	  var name = knownMemory.get(id)
	  
	  if(name == null){
	  	var String[] names = memory.eResource().getURI().lastSegment().split(".sharedMemory").get(0).split("_")
	  	
	  	name = NamingUtilities.getPrefix(memory.eResource.URI.path, ProjectCreator.getProject(memory.eResource).getFolder("src-gen"));
	  	for(String n : names) {
	  		name = name + n.toFirstUpper
	  	}
	  	
	  	//save the memory name
	  	knownMemory.put(IDHasher.GetIntHash(name), name)
	  }
		
	  return name
	}
	
	def static Clear(){
		knownMemory.clear
		externSharedMemoryVars.clear()
	}
	
}