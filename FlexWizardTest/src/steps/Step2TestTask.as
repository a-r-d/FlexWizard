package steps
{
	import com.roughbros.flexwizard.Step;
	
	import flash.utils.Dictionary;
	
	import mx.controls.DateField;
	
	public class Step2TestTask extends Step
	{
		
		[SkinPart(required="true")]
		public var taskStart:DateField;
		
		[SkinPart(required="true")]
		public var taskEnd:DateField;
		
		public function Step2TestTask()
		{
			super();
			
			this.stepName = "Pick Task Date";
			this.stepDescription = "Set your Task Date";
			
			this.setStyle( "skinClass", Step2TestTaskSkin );
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