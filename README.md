FlexWizard
==========

Reusable Flex Wizard component based entirely on Spark Components. 
Comes with default skin classes and a fleshed-out example. The wizard is 
useful for building CRUD apps where the data is complex is enough that
the user will become lost or confused while attempting to get through 
data entry.

## [get the SWC file](https://github.com/a-r-d/FlexWizard/tree/master/FlexWizard/bin)

![Image](https://raw.github.com/a-r-d/FlexWizard/master/screenshots/example_wizard_1.png)

## Overview

The FlexWizard consistes of a _Wizard_ component that _Steps_ are loaded into.
You can initialize a wizard instance with MXML or AS3 and there are examples 
of both.

You can use the default SkinClass that comes with the wizard or write your 
own if you want things to lay out differently. You do not have to customize the 
wizard to use it. Just create your own steps.

_Steps_ you create should extend _Step_ and override 3 methods:
 +  validateFunction():Boolean
 +  dataCreateFunction():Dictionary
 +  updateDataFunction():void


## Things you should do: An Explanation of Overrides

### validateFunction():Boolean

In this one you basically want to inspect your form fields on your step and 
return a true if they are OK, and false if they are bad. This will change the 
state of the item renderer for the step list.


### dataCreateFunction():Dictionary

Here you will inspect your form elements and create a dictionary of the values.
You are writing the step so do whatever you want and call the keys whatever you
want. Pull them back out when the user clicks _finish_, you can even call 
_compileStepData()_ on the wizard instance and it will give you back an array 
of all the step's step data Dictionaries.


### updateDataFunction():void

If you will ever be editing the data in the wizard this is how you set the initial 
states of the form components with the old data. Make sure to set _stepData_ on
your step, and in your update function look there to get your data.


## Things you should not do:

Don't override _partAdded()_ without calling super.partAdded() or else you will
lose the autovalidation logic added in Step.as- if you don't want to hassle with
this, just go ahead and add a _FlexEvent.CREATION_COMPLETE_ listener to the
Step in the constructor and put your code there. 


## Build your wizard with MXML

You can make your wizard using MXML but you still have to create your _Steps_ 
to add to the wizard instance.

![Image](https://raw.github.com/a-r-d/FlexWizard/master/screenshots/wizard_mxml_1.png)


## Non linear step flow:

This wizard is very simple and designed specifically for non-branching linear flow. However,to accomidate repetitive actions such as repeatedly adding things to a list, and
to deal with optional branches you can add steps within steps. By setting sub-steps into the _stepSequence_ array of the parent step you can create branches.

### A brief step by step:

 + 1) Create a step you want to branch off of another step.
 + 2) Create a button on the parent that throws StepFlowEvent.STEP_SUBSEQ_LOOP_START and  
        set _this_ as the initial step.
 + 3) Listen for StepFlowEvent.STEP_LOOP_CONTINUE to get the data from the child step.


The next/prev buttons will skip over these sub sequence steps, and you 
will only be able to reach them with a StepFlowEvent.

If you fire StepFlowEvent.STEP_SUBSEQ_LOOP_START then you will return to the 
original parent event. If you fire StepFlowEvent.STEP_SUBSEQ_ONCE_START you 
will be able to go on the next step in the list.


## Problems / Features

You can open an issue or fix it and submit a pull request! I may not add a feature
but if you want to go for it and I will merge it in. 


## Thanks

Thanks to Roughbros Greenhouses- they were kind enough to let me open source
this component.