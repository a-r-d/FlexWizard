package steps
{
	import com.roughbros.flexwizard.Step;
	
	import flash.utils.Dictionary;
	
	import spark.components.DropDownList;
	
	public class Step3TaskTest extends Step
	{
		
		[SkinPart(required="true")]
		public var taskList:DropDownList;
		
		
		public function Step3TaskTest()
		{
			super();
			
			this.stepName = "Task Dependency";
			this.stepDescription = "Set dependency for your task.";

			this.setStyle( "skinClass", Step3TaskSkin );
		}
		
		
		
		override public function dataCreateFunction():Dictionary
		{
			if( taskList != null && taskList.selectedIndex != -1) {
				var dict:Dictionary = new Dictionary();
				dict["task"] = taskList.dataProvider.getItemAt( taskList.selectedIndex ).toString();
				return dict;
			} else {
				return null;
			}
		}
		
		override public function updateDataFunction():void
		{
			// TODO Auto Generated method stub
			super.updateDataFunction();
		}
		
		override public function validateFunction():Boolean
		{
			if( taskList != null ) {
				if( taskList.selectedIndex == -1 ) {
					validationMessage = "Task not selected.";
					return false;
				}
			}else {
				validationMessage = "Task not selected.";
				return false;
			}
			
			this.validationMessage = "";
			return true;
		}
		
		
	}
}