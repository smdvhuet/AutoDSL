package info.scce.cinco.product.autoDSL.generator

import de.jabc.cinco.meta.core.utils.EclipseFileUtils
import de.jabc.cinco.meta.core.utils.projects.ProjectCreator
import de.jabc.cinco.meta.plugin.generator.runtime.IGenerator
import info.scce.cinco.product.autoDSL.rule.rule.Rule
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import info.scce.cinco.product.autoDSL.rule.rule.Operation
import info.scce.cinco.product.autoDSL.rule.rule.PIDController
import info.scce.cinco.product.autoDSL.rule.rule.Negation
import info.scce.cinco.product.autoDSL.rule.rule.Addition
import info.scce.cinco.product.autoDSL.rule.rule.Multiplication
import info.scce.cinco.product.autoDSL.rule.rule.Maximum
import info.scce.cinco.product.autoDSL.rule.rule.Minimum
import info.scce.cinco.product.autoDSL.rule.rule.LogicalAnd
import info.scce.cinco.product.autoDSL.rule.rule.LogicalOr
import info.scce.cinco.product.autoDSL.rule.rule.Subtraction
import info.scce.cinco.product.autoDSL.rule.rule.Less
import info.scce.cinco.product.autoDSL.rule.rule.LessOrEqual
import info.scce.cinco.product.autoDSL.rule.rule.Input
import info.scce.cinco.product.autoDSL.rule.rule.NumberStaticInput
import info.scce.cinco.product.autoDSL.rule.rule.CarInput

class RuleGenerator implements IGenerator<Rule> {
	
	var IFolder mainFolder
	
	override generate(Rule rule, IPath targetDir, IProgressMonitor monitor) {
		
		val IProject project = ProjectCreator.getProject(rule.eResource())
		mainFolder = project.getFolder("src-gen")
		
		generateStatic()
		
		for(Operation op : rule.operations){
			if(op.incoming.nullOrEmpty){
				EclipseFileUtils.writeToFile(mainFolder.getFile("Rule.java"),
				'''
				public class Rule{
					public void aplyRule(){
						«generateRule(op)»
					}
					
					private float min(float[] values){
						float result = values[0];
						for(int i = 1; i < values.length; i++){
							float x = values[i];
							if(x < result){
								result = values[i];
							}
						}
						return result;
					}
					
					private float max(float[] values){
						float result = values[0];
						for(int i = 1; i < values.length; i++){
							float x = values[i];
							if(x > result){
								result = values[i];
							}
						}
						return result;
					}
				}
				''')
				return
			}
		}
	}
	
	def generateStatic(){
		
	}
	
	def CharSequence generateRule(Operation op){
		switch op{
			PIDController : generatePID(op)
			Negation : generateNegation(op)
			Addition : generateAdd(op)
			Multiplication : generateMult(op)
			Maximum : generateMax(op)
			Minimum : generateMin(op)
			LogicalAnd : generateAnd(op)
			LogicalOr : generateOr(op)
			Subtraction : generateSub(op)
			Less : generateLess(op)
			LessOrEqual : generateLessOrEqual(op)
			default : "//operation "+op.toString+" not found"
		}
	}
	
	//TODO Implement
	def generatePID(PIDController op)'''
	
	
	//PID Controller
	«if(!op.operationSuccessors.nullOrEmpty)generateRule(op.operationSuccessors.last)»
	'''
	
	def generateNegation(Negation op)'''
	
	
	//Negation Operator
	boolean «op.outputs.head.id» = !«op.inputs.head.referenceInput»;
	«if(!op.operationSuccessors.nullOrEmpty)generateRule(op.operationSuccessors.last)»
	'''
	
	def generateAdd(Addition op)'''
	
	
	//Addition Operator
	float «op.outputs.head.id» = «FOR in : op.inputs SEPARATOR '+'»«
									in.referenceInput»«
								ENDFOR»;
	«if(!op.operationSuccessors.nullOrEmpty)generateRule(op.operationSuccessors.last)»
	'''
	
	def generateMult(Multiplication op)'''
	
	
	//Multiplication Operator
	float «op.outputs.head.id» = «FOR in : op.inputs SEPARATOR '*'»«
									in.referenceInput»«
								ENDFOR»;
	«if(!op.operationSuccessors.nullOrEmpty)generateRule(op.operationSuccessors.last)»
	'''
	
	def generateMax(Maximum op)'''
	
	
	//Max Operator
	float[] «op.id» = {«FOR  in : op.inputs SEPARATOR ','»«
						in.referenceInput»«
						ENDFOR»}
	float «op.outputs.head.id» = max(«op.id»);
	«if(!op.operationSuccessors.nullOrEmpty)generateRule(op.operationSuccessors.last)»
	'''
	
	def generateMin(Minimum op)'''
	
	
	//Min Operator
	float[] «op.id» = {«FOR  in : op.inputs SEPARATOR ','»«
							in.referenceInput»«
						ENDFOR»}
	float «op.outputs.head.id» = min(«op.id»);
	«if(!op.operationSuccessors.nullOrEmpty)generateRule(op.operationSuccessors.last)»
	'''
	
	def generateAnd(LogicalAnd op)'''
	
	
	//And Operator
	boolean «op.outputs.head.id» = «FOR in : op.inputs SEPARATOR '&&'»«
										in.referenceInput»«
									ENDFOR»;
	«if(!op.operationSuccessors.nullOrEmpty)generateRule(op.operationSuccessors.last)»
	'''
	
	def generateOr(LogicalOr op)'''
	
	
	//Or Operator
	boolean «op.outputs.head.id» = «FOR in : op.inputs SEPARATOR '||'»«
											in.referenceInput»«
										ENDFOR»;
	«if(!op.operationSuccessors.nullOrEmpty)generateRule(op.operationSuccessors.last)»
	'''
	
	def generateSub(Subtraction op)'''
	
	
	//Substraction Operator
	float «op.outputs.head.id» = «op.inputs.head.referenceInput» - «op.inputs.last.referenceInput»;
	«if(!op.operationSuccessors.nullOrEmpty)generateRule(op.operationSuccessors.last)»
	'''
	
	def generateLess(Less op)'''
	
	
	//Less Operator
	boolean «op.outputs.head.id» = «op.inputs.head.referenceInput» < «op.inputs.last.referenceInput»;
	«if(!op.operationSuccessors.nullOrEmpty)generateRule(op.operationSuccessors.last)»
	'''
	
	def generateLessOrEqual(LessOrEqual op)'''
	
	
	//LessOrEqual Operator
	boolean «op.outputs.head.id» = «op.inputs.head.referenceInput» <= «op.inputs.last.referenceInput»;
	«if(!op.operationSuccessors.nullOrEmpty)generateRule(op.operationSuccessors.last)»
	'''
	
	def referenceInput(Input in){
		switch in{
			NumberStaticInput :	in.staticValue
			CarInput :	in.inputtype.toString
			default :	if(in.predecessors.nullOrEmpty){
							"/*input not a reference*/"
						}else{
							in.predecessors.head.id
						}
		}	
	}
	
}