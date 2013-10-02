package com.roughbros.flexwizard
{
	import com.roughbros.flexwizard.skins.DefaultWizardSkinClass;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFactory;
	import mx.events.DragEvent;
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
		private var lastStep:Step;
		private var currentStep:Step;
		
		// this will reset itself after loop occurs
		private var sequence:Boolean = false;
		private var loopMode:Boolean = false;
		private var parentOfSequence:Step;
		private var currentStepOfSequence:Step;
		
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
		
		private var _wiz_mode:String = WIZ_MODE_CREATE;
		
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
			try{
				_steps = value;
				this.stepsArr = new ArrayCollection( _steps );
				
				/**
				 * Handle step sequences.
				 * 		1. add the substeps to the list in the correct location.
				 */
				var stepsWithSequences:Array = [];
				for each( var step:Step in _steps ) {
					if( step.stepSequence.length > 0 ){
						stepsWithSequences.push( step );
					}
				}
				
				var parentPosition:int = 0;
				for each( var step:Step in stepsWithSequences ) {
					var i:int = 0;
					for each( var stepParent:Step in _steps ) {
						if( stepParent == step ){
							parentPosition = i;
							break;
						}
						i++;
					}
					var ii:int = 0;
					for each( var substep:Step in step.stepSequence ) {
						stepsArr.addItemAt( substep, parentPosition + ii + 1 ); // + 1 so after the slected step.
						ii++;
					}
				}
				
				// Configure event listeners for Non-Linear flow cases.
				for each( var step:Step in stepsArr ) {
					step.addEventListener( 
						StepFlowEvent.STEP_SUBSEQ_LOOP_START, startLoop);
					
					step.addEventListener( 
						StepFlowEvent.STEP_SUBSEQ_ONCE_START, startSubSeq);
				}
				
				if( wiz_mode == WIZ_MODE_UPDATE ) {
					for each( var step:Step in stepsArr ) {
						step.updateDataFunction();	
					}
				}
				
				if( contentVGroup != null ) {
					switchStep( Step(stepsArr.getItemAt(0)) );
				}
				
			} catch( e:Error ) {
				trace( "Error setting steps! " + e.message  );
				throw new Error("Error setting steps! " + e.message );
			}
		}

		/**
		 * Switch to step, and jump back to previous when we 
		 * 
		 * 	This is a start loop.
		 */
		private function startLoop( e:StepFlowEvent):void {
			this.sequence = true;
			this.loopMode = true;
			parentOfSequence = e.initialStep;
			var i = 0;
			for each( var step:Step in stepsArr ) {
				if( step == e.initialStep && step.stepSequence.length > 0) {
					var stepSeqFirst:Step = Step(step.stepSequence[0]);
					this.currentStepOfSequence = stepSeqFirst;
					switchStep( currentStepOfSequence );
					lstStepList.selectedIndex = i + 1;
					break;
				}
				i++;
			}
		}
		
		private function startSubSeq( e:StepFlowEvent):void {
			this.sequence = true;
			this.loopMode = false;			
			parentOfSequence = e.initialStep;
			var i = 0;
			for each( var step:Step in stepsArr ) {
				if( step == e.initialStep && step.stepSequence.length > 0) {
					var stepSeqFirst:Step = Step(step.stepSequence[0]);
					this.currentStepOfSequence = stepSeqFirst;
					switchStep( currentStepOfSequence );
					lstStepList.selectedIndex = i + 1;
					break;
				}
				i++;
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
			if( sequence ) {
				return; // do nothing in a sequence.	
			}
			// this will do two things:
			// 1. trigger validation
			// 2. move the wizard to the step.
			if( lstStepList.selectedIndex > -1 ) {
				var step:Step = steps[ lstStepList.selectedIndex ]; 
				if( step.parentStepInstance != null ) {
					return; // we don't want to go to a branch step from the list.
				}
				step.validateData();
				switchStep( step );
			}
		}
		
		private function next( me:MouseEvent ):void {
			if( sequence ) {
				navigateSequenceMode( true );
				return;
			}
			
			var targetIncrement:int = getIncrement( true );
			
			if( lstStepList.selectedIndex != -1 && lstStepList.selectedIndex < stepsArr.length - 1 ) {
				var step:Step = steps[ lstStepList.selectedIndex + targetIncrement];
				lstStepList.selectedIndex = lstStepList.selectedIndex + targetIncrement;
				switchStep( step );
			} 
		}
		
		private function prev( me:MouseEvent ):void {
			if( sequence ) {
				navigateSequenceMode( false );
				return;
			}
			
			var targetIncrement:int = getIncrement( false );
			
			if( lstStepList.selectedIndex != -1 && lstStepList.selectedIndex > 0 ) {
				var step:Step = steps[ lstStepList.selectedIndex + targetIncrement];
				lstStepList.selectedIndex = lstStepList.selectedIndex + targetIncrement;
				switchStep( step );
			}
		}
		
		/***
		 * 
		 * This function provides the logic to skip over subsequences.
		 * 
		 * Special case: Subsequence is last step.
		 * Impossible case: Subsequence is first step.
		 * 
		 */
		private function getIncrement( forward:Boolean = true ):int  {
			var targetIncrement:int;
			if( forward ) {
				targetIncrement = 1;
			} else {
				targetIncrement = -1;
			}
			var subsequence:Boolean = true;
			while( subsequence ) {
				if( lstStepList.selectedIndex != -1 && 
					lstStepList.selectedIndex + targetIncrement < steps.length - 1 &&
					lstStepList.selectedIndex + targetIncrement >= 0
				) {
					var step:Step = steps[ lstStepList.selectedIndex + targetIncrement];
					// We know it is subsequence if the parent step is set.
					if( step.parentStep != null ) {
						// case: subsequence is last step.
						if( steps.length  <= lstStepList.selectedIndex + targetIncrement ) {
							targetIncrement = 0;
							break;
						}
						if( forward ) {
							targetIncrement++;
						} else {
							targetIncrement--;
						}
						continue;
					} else {
						subsequence = false;
					}
				} else {
					subsequence = false;
				}
			}
			return targetIncrement;
		}
		
		/***
		 * performs the loop logic when in loop mode.
		 * 
		 * 	For now we only go forward.
		 */
		private function navigateSequenceMode( forward:Boolean ):void {
			// We notify the parent in case it wants to get some data.
			if( loopMode ) {
				parentOfSequence.dispatchEvent( 
					new StepFlowEvent(StepFlowEvent.STEP_SUBSEQ_LOOP_CONTINUE, parentOfSequence, currentStep, null ));
			} else {
				parentOfSequence.dispatchEvent( 
					new StepFlowEvent(StepFlowEvent.STEP_SUBSEQ_ONCE_CONTINUE, parentOfSequence, currentStep, null ));
			}
			
			/**
			 * Try to go to next step of the sequence.
			 * 		
			 */
			var seqArr:Array = parentOfSequence.stepSequence;
			var parentPositon:int = stepsArr.getItemIndex( parentOfSequence );
			var stepIndexTarget:int = 0;
			if( forward ) {
				stepIndexTarget = lstStepList.selectedIndex + 1;
			} else {
				stepIndexTarget = lstStepList.selectedIndex - 1;
			}
			
			// if we are at end or begining - move back or do nothing...
			if( seqArr.length <= 1 || stepIndexTarget >= stepsArr.length ){
				loopMode = false;
				sequence = false;
				if( loopMode ) {
					switchStep( parentOfSequence );
					lstStepList.selectedIndex = stepIndexTarget;
					sequence = false;
					loopMode = false;
				} 
			} else {
				// in this case:
				/* 1. move forward down the sequence
				 * 2. go to the next
				 */
				var proposedStep:Step = Step(stepsArr.getItemAt( stepIndexTarget ));
				if( loopMode && proposedStep.parentStepInstance == null){
					switchStep( parentOfSequence );
					lstStepList.selectedIndex = parentPositon;
					sequence = false;
					loopMode = false;
				} else if(loopMode == false && proposedStep.parentStepInstance == null){
					switchStep( proposedStep );
					lstStepList.selectedIndex = stepIndexTarget;
					sequence = false;
					loopMode = false;
				}else {
					switchStep( proposedStep );
					lstStepList.selectedIndex = stepIndexTarget;
					if( proposedStep == parentOfSequence ) {
						sequence = false;
						loopMode = false;
					}
				}
			}
		}
		
		/***
		 * Try to finish the action.
		 * 	not finished until you dispatch a FINISH wizard event
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
				currentStep = step;
				
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

		[Inspectable(category="General", enumeration="WIZ_CREATE,WIZ_UPDATE", defaultValue="WIZ_CREATE")]
		public function get wiz_mode():String
		{
			return _wiz_mode;
		}

		public function set wiz_mode(value:String):void
		{
			_wiz_mode = value;
		}

		

	}
}