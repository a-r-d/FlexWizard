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
		
		// deal with step sequences:
		private var _parentStep:Class = null; // set to parent class if has one.
		private var _parentStepInstance:Step;
		private var _stepSequence:Array = [];
		
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
		
		// called by Wizard.as
		public function validateData():Boolean {
			valid = validateFunction();
			this.dispatchEvent( new StepEvent( StepEvent.STEP_VALIDITY_CHANGED, this ));
			return valid;
		}
		
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
			super.partAdded(partName, instance);
			
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

		public function get parentStep():Class
		{
			return _parentStep;
		}

		public function set parentStep(value:Class):void
		{
			_parentStep = value;
		}

		public function get stepSequence():Array
		{
			return _stepSequence;
		}

		[ArrayElementType("com.roughbros.flexwizard.Step")]
		public function set stepSequence(value:Array):void
		{
			_stepSequence = value;
			
			if( _stepSequence.length > 0 ) {
				for each( var s:Step in _stepSequence ) {
					var stepClassName:Class = Object(this).constructor;
					s.parentStep = stepClassName;
					s.parentStepInstance = this;
				}
			}
			
		}

		public function get parentStepInstance():Step
		{
			return _parentStepInstance;
		}

		public function set parentStepInstance(value:Step):void
		{
			_parentStepInstance = value;
		}
		
		
	}
}