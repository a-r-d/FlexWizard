
package com.roughbros.flexwizard {
	
	import flash.events.Event;
	
	public class WizardEvent extends Event {
		
		public static const NEXT_STEP:String = "next";
		public static const PREV_STEP:String = "prev";
		public static const WIZARD_FINISH_OK:String = "finish_ok";
		public static const WIZARD_FINISH_FAIL:String = "finish_fail";		
		public static const WIZARD_CLICK_FINISH:String = "finish_wizard_click";			
		public static const WIZARD_CANCEL:String = "wizardCancel";
		
		public function WizardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
	}
}