package steps
{
	import com.roughbros.flexwizard.Step;
	import com.roughbros.flexwizard.StepFlowEvent;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.controls.DateField;
	
	import spark.components.Button;
	
	public class Step2TestTask extends Step
	{
		[SkinPart(required="true")]
		public var taskStart:DateField;
		
		[SkinPart(required="true")]
		public var taskEnd:DateField;
		
		[SkinPart(required="true")]
		public var btnStartSubSequence:Button;
		
		public function Step2TestTask()
		{
			super();
			
			this.stepName = "Pick Task Date";
			this.stepDescription = "Set your Task Date";
			
			this.setStyle( "skinClass", Step2TestTaskSkin );
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			// TODO Auto Generated method stub
			super.partAdded(partName, instance);
			
			if( instance == btnStartSubSequence ) {
				btnStartSubSequence.addEventListener( MouseEvent.CLICK, initSubSequence );
			}
		}
		
		private function initSubSequence( e:MouseEvent ):void {
			if( this.stepSequence.length > 0 ) {
				dispatchEvent( new StepFlowEvent(
					StepFlowEvent.STEP_SUBSEQ_LOOP_START, this, null, null ));
			}
		}
		
		
		override public function dataCreateFunction():Dictionary
		{
			var dict:Dictionary = new Dictionary();
			if( taskStart != null && taskStart.selectedDate != null) {
				dict["start"] = taskStart.selectedDate;
			} 
			if( taskEnd != null && taskEnd.selectedDate != null) {
				dict["end"] = taskEnd.selectedDate;
			}
			return dict;
		}
		
		override public function updateDataFunction():void
		{
			// TODO Auto Generated method stub
			super.updateDataFunction();
		}
		
		override public function validateFunction():Boolean
		{
			
			if( taskStart == null || taskEnd == null ) {
				return false;
			}
			
			if( taskStart.selectedDate == null ) {
				this.validationMessage = "Start Date Not Set.";
				return false;
			}
			
			if( taskEnd.selectedDate == null ) {
				this.validationMessage = "End Date Not Set.";
				return false;
			}
			
			if( taskStart.selectedDate.time > taskEnd.selectedDate.time ) {
				this.validationMessage = "Start Date must be before End Date.";
				return false;
			}
			
			this.validationMessage = "";
			return true;
		}
		
		

	}
}