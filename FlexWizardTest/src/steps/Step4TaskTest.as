package steps
{
	import com.roughbros.flexwizard.Step;
	
	import flash.utils.Dictionary;
	
	import spark.components.CheckBox;
	import spark.components.DropDownList;
	
	public class Step4TaskTest extends Step
	{
		
		
		[SkinPart(required="true")]
		public var userList:DropDownList;
		
		[SkinPart(required="true")]
		public var chkSendAlert:CheckBox;
		
		
		public function Step4TaskTest()
		{
			super();

			
			this.stepName = "Assign Task To";
			this.stepDescription = "Select a user to assign the task to. Select Email notification Preferences.";
			
			this.setStyle( "skinClass", Step4TaskTestSkin );
		}
		
		
		
		
		override public function dataCreateFunction():Dictionary
		{
			var dict:Dictionary = new Dictionary();
			
			if( userList != null && userList.selectedIndex != -1) {
				dict["user"] = userList.dataProvider.getItemAt( userList.selectedIndex ).toString();
				return dict;
			} 
			
			if( chkSendAlert != null ) {
				dict["email"] = chkSendAlert.selected;
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
			if( userList != null ) {
				if(userList.selectedIndex == -1 ) {
					validationMessage = "User not selected.";
					return false;
				}
			}else {
				validationMessage = "User not selected.";
				return false;
			}
			
			this.validationMessage = "";
			return true;
		}
		
	}
}