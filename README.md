FlexWizard
==========

Reusable Flex Wizard component based entirely on Spark Components. 
Comes with default skin classes and a fleshed-out example. The wizard is 
useful for building CRUD apps where the data is complex is enough that
the user will become lost or confused while attempting to get through 
data entry.


![Image](https://raw.github.com/a-r-d/FlexWizard/master/screenshots/example_wizard_1.png)

## Overview

The FlexWizard consistes of a _Wizard_ component that _Steps_ are loaded into.
You can initialize a wizard instance with MXML or AS3 and there are examples 
of both.

You can use the default SkinClass that comes with the wizard or write your 
own if you want things to lay out differently. 

_Steps_ you create should extend _Step_ and override 3 methods:
 +  validateFunction():Boolean
 +  dataCreateFunction():Dictionary
 +  updateDataFunction():void


## Explanation of Overrides:

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

If you will ever be editing the in the wizard this is how you set the initial 
states of the form components with the old data. Make sure to set _stepData_ on
your step, and in your update function look there to get your data.

## Thanks

Thanks to Roughbros Greenhouses- they were kind enough to let me open source
this component.