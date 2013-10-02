package com.roughbros.flexwizard
{
	import flash.events.Event;
	
	public class StepFlowEvent extends Event
	{
		public static const STEP_SUBSEQ_LOOP_START:String = "SUBSEQ_LOOP_START";
		public static const STEP_SUBSEQ_LOOP_CONTINUE:String = "SUBSEQ_LOOP_CONTINUE";
		public static const STEP_SUBSEQ_LOOP_END:String = "SUBSEQ_LOOP_END";
		
		public static const STEP_SUBSEQ_ONCE_START:String = "SUBSEQ_ONCE_START";
		public static const STEP_SUBSEQ_ONCE_CONTINUE:String = "SUBSEQ_ONCE_CONTINUE";
		public static const STEP_SUBSEQ_ONCE_END:String = "SUBSEQ_ONCE_END";

		public var initialStep:Step;
		public var currentStep:Step;
		public var nextStep:Step;
				
		/**********************************************************************
		 *  Loop:
		 * 		Case 1. - Starting a loop subsequence. Go to first substep.
		 * 		Case 2. - Continuing on loop subsequence. Go to next substep.
		 * 		Case 3. - End loop subsequence. Go back to parent step.
		 * 
		 *  Once:
		 * 		Case 1. - start subseq.
		 * 		Case 2. - continue subseq.
		 * 		Case 3. - end subseq and continue on.
		 **********************************************************************/
		public function StepFlowEvent(
		      type:String, 
			  initialStep:Step, 
			  currentStep:Step, 
			  nextStep:Step, 
			  bubbles:Boolean=false, 
			  cancelable:Boolean=false)
		{
			this.initialStep = initialStep;
			this.currentStep = currentStep;
			this.nextStep = nextStep;
			
			super(type, bubbles, cancelable);
		}
	}
}