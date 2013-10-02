package steps
{
	import com.roughbros.flexwizard.Step;
	import com.roughbros.flexwizard.StepFlowEvent;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.core.IDeferredContentOwner;
	import mx.core.IVisualElementContainer;
	
	import spark.components.Button;
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	public class Step1TestTask extends Step
	{
		
		[SkinPart(required="true")]
		public var taskName:TextInput;
		
		[SkinPart(required="true")]
		public var taskDescription:TextArea;

		public function Step1TestTask()
		{
			super();
			
			this.stepName =  "Task Name";
			this.stepDescription = "Name and description for your task.";
			
			this.setStyle( "skinClass", Step1TestTaskSkin );
		}
		
		override public function dataCreateFunction():Dictionary
		{
			var dict:Dictionary = new Dictionary();
			if( taskName != null && taskName.text != null) {
				dict["name"] = taskName.text;
			} 
			if( taskDescription != null && taskDescription.text != null) {
				dict["description"] = taskDescription.text;
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
			if( taskName.text == "") {
				this.validationMessage = "Task Name not set.";
				return false;
			}
			
			if( taskDescription.text == "" ) {
				this.validationMessage = "Task Description not set."
				return false;
			}
			
			this.validationMessage = "";
			return true;
		}
		
		
		
	}
}