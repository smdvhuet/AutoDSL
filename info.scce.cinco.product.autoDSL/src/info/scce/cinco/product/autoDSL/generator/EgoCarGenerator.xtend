package info.scce.cinco.product.autoDSL.generator

class EgoCarGenerator {
	
	def generateEgoCar()'''
	package info.scce.cinco.product;
	
	public class EgoCar{
		private double posM;
		    
		private double velocityMPerSec;
		    
		private final double massKg = 1370.0;
		    
		private final double f0 = 51.0;
		
		private final double f1 = 1.2567;
		
		private final double f2 = 0.4342;
		
		private StateMachine acc;
		
		public EgoCar(double posM, double velocityMPerSec) {
			this.posM = posM;
			this.velocityMPerSec = velocityMPerSec;
			
			acc = new StateMachine();
			Rule rule = new Rule();
			rule.Geschwindigkeit = velocityMPerSec;
			acc.SetEntryState(rule);
		}
		
		
		    
		public void step(double dTimeSec) {
			((Rule)acc.getCurrentState()).Geschwindigkeit = this.velocityMPerSec;
			
			acc.Run();
			double force = this.velocityMPerSec + ((Rule)acc.getCurrentState()).Geschwindigkeit;
		    
			if (velocityMPerSec == 0 && force == 0) {
				return;
			}
		        
			double vDot = (force - (f0 + f1 * velocityMPerSec + f2 * velocityMPerSec * velocityMPerSec)) / massKg * dTimeSec;
			double xDot = velocityMPerSec * dTimeSec;
		        
			this.velocityMPerSec += vDot;
			this.posM += xDot;
		}
		    
		public double getPositionM() {
			return posM;
		}
		
		
		public double getVelocity() {
			return velocityMPerSec;
		}
		
	}
	'''
}