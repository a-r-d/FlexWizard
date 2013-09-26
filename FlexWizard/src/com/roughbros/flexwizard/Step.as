package com.roughbros.flexwizard
{
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	
	import spark.components.SkinnableContainer;

	
	public class Step extends SkinnableContainer
	{	
		/**
		 * Arbitrary data that is passed to step.
		 */		
		private var _stepData:Dictionary;
		private var _valid:Boolean = false;
		private var _validationMessage:String = "";
		private var _stepName:String;
		private var _stepDescription:String;
		private var _automaticValidation:Boolean = true;
		
		public function Step()
		{
			super();
		}
		
		// OVERRIDE THIS
		public function validateFunction():Boolean {
			return true;
		}
		// OEVRRIDE THIS
		public function dataCreateFunction():Dictionary {
			return new Dictionary();
		}
		// OVERRIDE THIS
		public function updateDataFunction():void {
			return;
		}
		
		/****
		 * 
		 * Validation function:
		 * 		returns: Boolean
		 * 		Note:
		 * 			Pass in a function that returns boolean
		 * 			after some validation is done on the stepData.
		 */
		
		public function validateData():Boolean {
			valid = validateFunction();
			this.dispatchEvent( new StepEvent( StepEvent.STEP_VALIDITY_CHANGED, this ));
			return valid;
		}
		
		/****
		 * Data create function:
		 * 		returns data Dictionary.
		 * 		set this in your step instance,
		 * 		gives a dictionary of your step data
		 * 
		 * When you call createData it returns empty dict
		 * 	if no fn.
		 * 
		 */
		// called by Wizard.as
		public function createData():Dictionary {
			this._stepData = dataCreateFunction();
			return _stepData;
		}
		
		
		//////////////////////////////////////////////////////////////
		/***
		 * Part added will run validation for on change and on keydown
		 * but only if it is turned on and we encounter a UIComponent.
		 */
		override protected function partAdded(partName:String, instance:Object) : void {
			if( automaticValidation ) {
				if( instance is UIComponent ) {
					var cmp:UIComponent = UIComponent(instance);
					
					var step:Step = this;
					
					cmp.addEventListener( KeyboardEvent.KEY_UP, function():void {
						validateData();
						dispatchEvent(new StepEvent( StepEvent.STEP_REVALIDATED, step, true ));
					});
					cmp.addEventListener( Event.CHANGE, function():void {
						validateData();
						dispatchEvent(new StepEvent( StepEvent.STEP_REVALIDATED, step, true ));

					});
				}
			}
		}
				

		public function get validationMessage():String
		{
			return _validationMessage;
		}

		public function set validationMessage(value:String):void
		{
			_validationMessage = value;
		}

		public function get stepName():String
		{
			return _stepName;
		}

		public function set stepName(value:String):void
		{
			_stepName = value;
		}

		public function get stepDescription():String
		{
			return _stepDescription;
		}

		public function set stepDescription(value:String):void
		{
			_stepDescription = value;
		}

		public function get valid():Boolean
		{
			return _valid;
		}

		public function set valid(value:Boolean):void
		{
			_valid = value;
		}

		public function get stepData():Dictionary
		{
			return _stepData;
		}

		public function set stepData(value:Dictionary):void
		{
			_stepData = value;
		}

		public function get automaticValidation():Boolean
		{
			return _automaticValidation;
		}

		public function set automaticValidation(value:Boolean):void
		{
			_automaticValidation = value;
		}
		
		
	}
}