package info.scce.cinco.product.autoDSL.generator

import de.jabc.cinco.meta.plugin.generator.runtime.IGenerator
import info.scce.cinco.product.autoDSL.sharedMemory.sharedmemory.SharedMemory
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import java.util.ArrayList
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IFolder
import de.jabc.cinco.meta.core.utils.projects.ProjectCreator
import de.jabc.cinco.meta.core.utils.EclipseFileUtils
import info.scce.cinco.product.autoDSL.autodsl.autodsl.AutoDSL
import java.util.HashMap

class SharedMemoryGenerator  implements IGenerator<AutoDSL> {
	
	var HashMap<Integer, String> knownMemory =  new HashMap<Integer, String>()
	
	override generate(AutoDSL dsl, IPath targetDir, IProgressMonitor monitor) {
		val ArrayList<SharedMemory> sharedMemories = new ArrayList<SharedMemory>()
		for(state:dsl.states){
			for(node:state.componentNodes){
				for(it:node.rule.loadBooleans){
					if(!sharedMemories.contains(it.data.rootElement)){
						sharedMemories.add(it.data.rootElement)
					}
				}
				for(it:node.rule.loadNumbers){
					if(!sharedMemories.contains(it.data.rootElement)){
						sharedMemories.add(it.data.rootElement)
					}
				}
				for(it:node.rule.storedPIDControllers){
					if(!sharedMemories.contains(it.data.rootElement)){
						sharedMemories.add(it.data.rootElement)
					}
				}
				for(it:node.rule.saveBooleans){
					if(!sharedMemories.contains(it.data.rootElement)){
						sharedMemories.add(it.data.rootElement)
					}
				}
				for(it:node.rule.saveNumbers){
					if(!sharedMemories.contains(it.data.rootElement)){
						sharedMemories.add(it.data.rootElement)
					}
				}
			}
		}
		for(guard:dsl.guards){
			for(node:guard.componentNodes){
				for(it:node.rule.loadBooleans){
					if(!sharedMemories.contains(it.data.rootElement)){
						sharedMemories.add(it.data.rootElement)
					}
				}
				for(it:node.rule.loadNumbers){
					if(!sharedMemories.contains(it.data.rootElement)){
						sharedMemories.add(it.data.rootElement)
					}
				}
				for(it:node.rule.storedPIDControllers){
					if(!sharedMemories.contains(it.data.rootElement)){
						sharedMemories.add(it.data.rootElement)
					}
				}
				for(it:node.rule.saveBooleans){
					if(!sharedMemories.contains(it.data.rootElement)){
						sharedMemories.add(it.data.rootElement)
					}
				}
				for(it:node.rule.saveNumbers){
					if(!sharedMemories.contains(it.data.rootElement)){
						sharedMemories.add(it.data.rootElement)
					}
				}
			}
		}
		if(sharedMemories.nullOrEmpty){
			return
		}
		val ArrayList<String> srcFolders = new ArrayList<String>()
		srcFolders.add("src-gen")
		
		val IProject project = ProjectCreator.getProject(dsl.eResource)
		var IFolder mainFolder = project.getFolder("src-gen")
		EclipseFileUtils.mkdirs(mainFolder,monitor)
		EclipseFileUtils.writeToFile(mainFolder.getFile("SharedMemory.h"), generateStruct(sharedMemories))
	}
	
//*********************************************************************************
//							generating SharedMemory.h
//*********************************************************************************
	def generateStruct(ArrayList<SharedMemory> memories)'''
	#ifndef SHARED_MEMORY_H_
	#define SHARED_MEMORY_H_
	
	#include "core/PID.h"
	
	namespace SharedMemory{
		«FOR memory:memories»
		struct «memory.memoryName»{
			//bools
			«FOR bool:memory.storedBooleans»
			bool «bool.label» = «bool.defaultValue»;
			«ENDFOR»
			
			//numbers
			«FOR number:memory.storedNumbers»
			double «number.label» = «number.defaultValue»;
			«ENDFOR»
			
			//PIDs
			«FOR pid:memory.storedPIDControllers»
			bool «pid.label»(«pid.p»,«pid.i»,«pid.d»)
			«ENDFOR»
		};
		«ENDFOR»
	}
	#endif
	'''
	
	def getMemoryName(SharedMemory memory){
	  var id = 	IDHasher.GetIntHash(memory.id);
	  var name = knownMemory.get(id);
	  
	  if(name == null){
	  	var String[] names = memory.eResource().getURI().lastSegment().split(".sharedMemory").get(0).split("_")
	  	
	  	name = "";
	  	for(String n : names) {
	  		name = name + n.toFirstUpper
	  	}
	  	
	  	//safe the memory name
	  	knownMemory.put(IDHasher.GetIntHash(name), name)
	  }
		
	  return name;
	}
	
}