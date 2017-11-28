package info.scce.cinco.product.autoDSL.generator

class StateMachineGenerator {
	static def StateMachineClass() '''
	import java.util.HashMap;
	import java.util.List;
	import java.util.ArrayList;
	import java.util.function.Predicate;
	
	public class StateMachine {
		//Describes the (conditional) transition from one known state to another 
		private class Transition{
			State targetState;
			Predicate<State> condition;
			
			public Transition(State targetState, Predicate<State> condition){
				assert(targetState != null);
				
				this.targetState = targetState;
				this.condition = condition;
			}
			
			@Override
			public boolean equals(Object obj){
				if(obj == null)
					return false;
				
				if(obj.getClass() != this.getClass())
					return false;
				
				Transition tmp = (Transition)obj;
				return targetState.equals(tmp.targetState) && condition.equals(tmp.condition);
			}
		}
		
		//Member variables
		private State currentState;
		private HashMap<State, List<Transition>> transitions; 
		
		private State entryState;
		
		//Constructor
		public StateMachine(){
			currentState = null;
			transitions = new HashMap<>();
			entryState = null;
		}
		
		//Executes the current state and tries to perform the transition to the next state
		public void Run(){
			assert(currentState != null);
			
			currentState.Execute();
			
			//Check for the first transition where the condition is fulfilled and follow that transition
			List<Transition> stateTransitions = transitions.get(currentState);
			for (Transition transition : stateTransitions) {
				if(transition.condition.test(currentState)){
					currentState.onExit();
					currentState = transition.targetState;
					currentState.onEntry();
					break;
				}
			}
		}
		
		public void AddTransition(State from, State to, Predicate<State> condition){
			List<Transition> stateTransitions = transitions.get(from);
			Transition newTransition = new Transition(to, condition);
			
			if(stateTransitions == null){
				stateTransitions = new ArrayList<>();
				stateTransitions.add(newTransition);
			}else if(!stateTransitions.contains(newTransition)){
				stateTransitions.add(newTransition);
			}
			
			transitions.put(from, stateTransitions);
		}
		
		public void SetEntryState(State entryState){
			this.entryState = entryState;
			
			if(currentState == null)
				this.currentState = this.entryState;
		}
		
		public boolean isInEntryState(){ return this.entryState.equals(this.currentState); }
		public State getCurrentState(){ return currentState; }
	}
	'''
	
	static def StateClass() '''
	interface State {
		abstract void onEntry();
		abstract void Execute();
		abstract void onExit();
		abstract String getName();
	}
	'''
}