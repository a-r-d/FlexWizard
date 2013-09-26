package com.roughbros.flexwizard
{
	import com.roughbros.flexwizard.skins.DefaultWizardSkinClass;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFactory;
	import mx.events.FlexEvent;
	import mx.states.SetStyle;
	
	import spark.components.Button;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.SkinnableContainer;
	import spark.components.VGroup;
	import spark.skins.spark.mediaClasses.fullScreen.FullScreenButtonSkin;
	
	public class Wizard extends SkinnableContainer
	{
		private var _steps:Array;
		
		[Bindable]
		private var stepsArr:ArrayCollection = new ArrayCollection();
		
		
		/**
		 * Skin parts:
		 * 
		 * *******************************************
		 * 		lblTitle 
		 * 			lblDescription
		 * *******************************************
		 *  l	*
		 *  s	*
		 *  t	*
		 *  S	*
		 *  t	*
		 *  e	*		contentVGroup
		 *  p	*
		 *  L	*
		 *  i	*
		 *  s	*
		 *  t	*
		 * *******************************************
		 * 		buttonContainer
		 * 			btnExit, btnPrev, btnNext, btnFinish
		 * *******************************************
		 */
		[SkinPart(required="true")]
		public var lstStepList:List;
		
		
		[SkinPart(required="true")]
		public var lblTitle:Label;
		
		[SkinPart(required="true")]
		public var lblDescription:Label;
		
		
		[SkinPart(required="true")]
		public var contentVGroup:VGroup;
		
		
		[SkinPart(required="true")]
		public var lblStepValidation:Label;
		
		
		[SkinPart(required="true")]
		public var buttonContainer:HGroup;
		
		[SkinPart(required="true")]
		public var btnNext:Button;
		
		[SkinPart(required="true")]
		public var btnPrev:Button;
		
		[SkinPart(required="true")]
		public var btnFinish:Button;
		
		[SkinPart(required="true")]
		public var btnExit:Button;
		
		/***
		 *  Settings:
		 * 		Wizard needs an easy way to to update vs create.
		 */
		public static const WIZ_MODE_CREATE:String = "WIZ_CREATE";
		public static const WIZ_MODE_UPDATE:String = "WIZ_UPDATE";
		public var wiz_mode:String = WIZ_MODE_CREATE;
		
		/***
		 * Constructor, getters, setters.
		 */
		
		public function Wizard()
		{
			super();
		    this.setStyle("skinClass", DefaultWizardSkinClass );
			this.addEventListener( StepEvent.STEP_REVALIDATED, stepRevalidate);
			this.addEventListener( FlexEvent.CREATION_COMPLETE, creationComplete );
		}
		
		private function creationComplete( e:FlexEvent ):void {
			if (steps.length >= 1) {
				lblTitle.text = steps[0].stepName;
				lblDescription.text = steps[0].stepDescription;
			}
		}
		

		/**
		 * returns Array of com.roughbros.flexwizard.Step
		 */
		public function get steps():Array
		{
			return _steps;
		}
		
		/**
		 * @private
		 */
		[ArrayElementType("com.roughbros.flexwizard.Step")]
		public function set steps(value:Array):void
		{
			_steps = value;
			this.stepsArr = new ArrayCollection( _steps );
			
			
			if( wiz_mode == WIZ_MODE_UPDATE ) {
				for each( var step:Step in steps ) {
					step.updateDataFunction();	
				}
			}
			
			if( contentVGroup != null ) {
				switchStep( steps[0] );
			}
		}

		
		/***
		 * Overrides:
		 */
		
		override protected function partAdded(partName:String, instance:Object) : void {
			super.partAdded(partName, instance);
			
			if(instance == lstStepList){
				lstStepList.labelField = "stepName";
				lstStepList.addEventListener(
					Event.CHANGE,
					stepListClick
				);
				lstStepList.dataProvider = stepsArr;
				lstStepList.selectedIndex = 0;
			}
			
			// must add the step as the content group is added.
			if( instance == contentVGroup ) {
				if( steps != null ) {
					switchStep( steps[0] );
				}
			}
			
			if( instance == btnNext ) {
				btnNext.addEventListener(MouseEvent.CLICK, next );
			}
			
			if( instance == btnPrev ) {
				btnPrev.addEventListener(MouseEvent.CLICK, prev );
			}
			
			if( instance == btnFinish ) {
				btnFinish.addEventListener(MouseEvent.CLICK, finish );
				btnFinish.enabled = false;
			}
			
			if( instance == btnExit ) {
				btnExit.addEventListener(MouseEvent.CLICK, exit);
			}
		}
		
		/***
		 * Event handlers:
		 */
		
		private function stepListClick( me:Event ):void {
			// this will do two things:
			// 1. trigger validation
			// 2. move the wizard to the step.
			if( lstStepList.selectedIndex > -1 ) {
				var step:Step = steps[ lstStepList.selectedIndex ]; 
				step.validateData();
				switchStep( step );
			}
		}
		
		private function next( me:MouseEvent ):void {
			if( lstStepList.selectedIndex != -1 && lstStepList.selectedIndex < stepsArr.length - 1 ) {
				var step:Step = steps[ lstStepList.selectedIndex + 1];
				lstStepList.selectedIndex = lstStepList.selectedIndex + 1;
				switchStep( step );
			} 
		}
		
		private function prev( me:MouseEvent ):void {
			if( lstStepList.selectedIndex != -1 && lstStepList.selectedIndex > 0 ) {
				var step:Step = steps[ lstStepList.selectedIndex - 1];
				lstStepList.selectedIndex = lstStepList.selectedIndex - 1;
				switchStep( step );
			}
		}
		
		/***
		 * 
		 * Try to finish the action.
		 * 	not finished until you dispatch a FINISH wizard event
		 * 
		 */
		public function finish( me:MouseEvent ):void {
			this.dispatchEvent( new WizardEvent( WizardEvent.WIZARD_CLICK_FINISH, true ));
		}

		private function exit( me:MouseEvent ):void {
			this.dispatchEvent( new WizardEvent( WizardEvent.WIZARD_CANCEL, true ));
		}
		
		private function switchStep( step:Step ):void {
			if( contentVGroup != null ) {
				contentVGroup.removeAllElements();
				contentVGroup.addElement( step );
				
				// validate the step.
				step.validateData();
				step.dispatchEvent( new StepEvent( StepEvent.STEP_VALIDITY_CHANGED, step ));
				
				// generate step data per fn.
				step.createData();
				
				// set title, ect.
				if( lblTitle != null )
					this.lblTitle.text = step.stepName;
				if( lblDescription != null )
					this.lblDescription.text = step.stepDescription;
				
				
				if( lblStepValidation != null ) {
					if( step != null) {
						lblStepValidation.text = step.validationMessage;
					}
				}
				stepRevalidate( null );
				
				// if last step:
				if( lstStepList != null && btnFinish != null) {
					if( lstStepList.selectedIndex == steps.length - 1) {
						this.btnFinish.enabled = true;
					} else {
						this.btnFinish.enabled = false;
					}
				}
			}
		}
		
		private function stepRevalidate( e:StepEvent ):void {
			if( lblStepValidation != null && e != null ) {
				if( e.step != null) {
					lblStepValidation.text = e.step.validationMessage;
				}
			}
		}
		
		public function validateAllSteps():Boolean {
			var allvalid:Boolean = true;

			for each( var s:Step in steps ){
				if( s.validateData() == false ) {
					allvalid = false;
					break;
				}
			}
			
			return allvalid;
		}
		
		public function compileStepData():Array {
			var stepDataDictionaries:Array = [];
			
			for each( var s:Step in steps ){
				stepDataDictionaries.push( s.createData() );
			}
			
			return stepDataDictionaries;
		}
		
		
		/***
		 * Utilities
		 */
		
		public static function toArray(iterable:*):Array {
			var ret:Array = [];
			for each (var elem:Object in iterable) ret.push(elem);
			return ret;
		}

		

	}
}