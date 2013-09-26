package com.roughbros.flexwizard {
	
	import flash.events.Event;
	
	public class StepEvent extends Event {
		
		public static const STEP_REVALIDATED:String = "step_revalidate";
		
		public static const STEP_VALIDITY_CHANGED:String = "step_validity_chng";
		
		public var step:Step;
		
		public function StepEvent(type:String, step:Step, bubbles:Boolean=false, cancelable:Boolean=false) {
			this.step = step;
			super(type, bubbles, cancelable);
		}
		
	}
}
