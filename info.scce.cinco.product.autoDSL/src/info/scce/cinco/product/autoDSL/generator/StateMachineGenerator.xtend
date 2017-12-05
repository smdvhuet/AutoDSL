package info.scce.cinco.product.autoDSL.generator

class StateMachineGenerator {
	static def StateMachineClass() '''	
	package info.scce.cinco.product;
	
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
		//Contains a state and all the transitions leading away from this state
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
	package info.scce.cinco.product;
	
	interface State {
		public abstract void onEntry();
		public abstract void Execute();
		public abstract void onExit();
		public abstract String getName();
	}
	'''
	
	static def MultiStateClass() '''
	package info.scce.cinco.product;
	
	import java.util.ArrayList;
	import java.util.List;
	
	public class MultiState implements State{
		private List<State> states = new ArrayList<>();
		
		public void onEntry(){
			for(State state : states)
				state.onEntry();
		}
		
		public void Execute(){
			for(State state : states)
				state.Execute();
		}
		
		public void onExit(){
			for(State state : states)
				state.onExit();
		}
		
		public String getName(){
			String rules = "MultiState";
			for(State state : states)
				rules += " " + state.getName();
			return rules;
		}
		
		public void AddState(State state){
			if(!states.contains(state))
				states.add(state);
		}
	}
	'''
}