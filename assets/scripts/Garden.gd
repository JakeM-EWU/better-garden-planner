extends Node2D

@onready var _garden_plan = $GardenPlan

##[method save_to_file]:
##Saves the Garden to a file
##The file must already be open for writing.
#For now this only saves the garden plan, but it can be extended
#to save other parts of a project
func save_to_file(file:FileAccess):
	_garden_plan.save_to_file(file)
	
	
##[method load_from_file]:
##Loads a Garden from a file. 
##The file must already be open for reading.
#For now this only loads the garden plan, but it can be extended
#to load other parts of a project
func load_from_file(file:FileAccess):
	_garden_plan.load_from_file(file)
