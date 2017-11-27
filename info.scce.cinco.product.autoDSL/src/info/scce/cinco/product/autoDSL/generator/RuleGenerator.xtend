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
	
	override generate(Rule rule, IPath targetDir, IProgressMonitor monitor) {
		val ArrayList<String> srcFolders = new ArrayList<String>();
		srcFolders.add("src-gen")
		
		val IProject project = ProjectCreator.createProject("Generated Product",srcFolders,null,null,null,null,monitor)
		mainFolder = project.getFolder("src-gen")
		generateStatic()
		
		val CharSequence nodes = new NodeGenerator().generate(rule);
		EclipseFileUtils.writeToFile(mainFolder.getFile("Rule.java"),nodes)
	}
	
	//TODO implement Car,Simulator,etc
	def generateStatic(){
		EclipseFileUtils.writeToFile(mainFolder.getFile("PID.java"),generatePIDClass())
	}
	
	def generatePIDClass()'''
		public class PID{
			private double p;
			private double i;
			private double d;
			
			private final double MAX_VALUE = Double.MAX_VALUE;
			private final double MIN_VALUE = Double.MIN_VALUE;
				
			private double lastValue = 0.0;
			private double integral = 0.0;
			
			public PID(double p, double i, double d){
				this.p = p;
				this.i = i;
				this.d = d;
			}
				
			public double calc(double currentValue, double targetValue, double dTimeSec){
				double error = targetValue - currentValue;
				double diff = (lastValue - error) / dTimeSec;
					
				lastValue = error;
				integral += (error * dTimeSec);  
					
				if(integral > MAX_VALUE)
					integral = MAX_VALUE;
				else if(integral < MIN_VALUE)
					integral = MIN_VALUE;
						
				return (error + i * integral + d * diff) * p;
			}
				
			public final double getP() { return p; }
			public final double getI() { return i; }
			public final double getD() { return d; }
		}
	'''
	
}