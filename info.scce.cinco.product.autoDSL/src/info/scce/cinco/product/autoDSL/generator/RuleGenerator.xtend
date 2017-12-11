package info.scce.cinco.product.autoDSL.generator

import de.jabc.cinco.meta.core.utils.EclipseFileUtils
import de.jabc.cinco.meta.core.utils.projects.ProjectCreator
import de.jabc.cinco.meta.plugin.generator.runtime.IGenerator
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import java.util.ArrayList

class RuleGenerator implements IGenerator<Rule> {
	
	var IFolder mainFolder
	var IFolder mainPackage
	
	override generate(Rule rule, IPath targetDir, IProgressMonitor monitor) {
		val ArrayList<String> srcFolders = new ArrayList<String>();
		srcFolders.add("src-gen")
		
		val IProject project = ProjectCreator.createProject("Generated Product",srcFolders,null,null,null,null,monitor)
		mainFolder = project.getFolder("src-gen")
		mainPackage = mainFolder.getFolder("info/scce/cinco/product")
		EclipseFileUtils.mkdirs(mainPackage,monitor)
		generateStatic()
		
		val CharSequence nodes = new NodeGenerator().generate(rule);
		EclipseFileUtils.writeToFile(mainPackage.getFile(rule.name + ".java"),nodes)
	}
	
	//TODO implement Car,Simulator,etc
	def generateStatic(){
		EclipseFileUtils.writeToFile(mainPackage.getFile("PID.java"), StaticClasses::PIDClass())
//		EclipseFileUtils.writeToFile(mainPackage.getFile("EgoCar.java"), new EgoCarGenerator().generateEgoCar())		
	}
}