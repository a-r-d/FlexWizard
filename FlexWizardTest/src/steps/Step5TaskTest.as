package steps
{
	import com.roughbros.flexwizard.Step;
	
	import flash.utils.Dictionary;
	
	import spark.components.Label;
	
	public class Step5TaskTest extends Step
	{
		
		[SkinPart(required="true")]
		public var lblComplete:Label;
		
		public function Step5TaskTest()
		{
			super();
			
			this.stepName = "Finish and Review Task";
			this.stepDescription = "Here is where you can review the potential task.";
			
			this.setStyle( "skinClass", Step5TaskTestSkin );
		}
		
		
		
		override public function dataCreateFunction():Dictionary
		{
			var dict:Dictionary = new Dictionary();
			return dict;
		}
		
		override public function updateDataFunction():void
		{
			// TODO Auto Generated method stub
			super.updateDataFunction();
		}
		
		override public function validateFunction():Boolean
		{

			this.validationMessage = "";
			return true;
		}
	}
}