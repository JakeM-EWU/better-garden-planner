class_name Garden
extends Node2D

@onready var _garden_plan: GardenPlan = $GardenPlan

var rows: int
var columns: int
var placed_objects: Array


func create_garden(rows: int, columns: int) -> void:
	self.rows = rows
	self.columns = columns
	for r in rows:
		placed_objects.append([])
		for c in columns:
			placed_objects[r].append("")
			

func place_object(row: int, column: int, object_key: String):
	placed_objects[row][column] = object_key
	GardenSignalBus.emit_signal("object_placed", row, column, object_key)

func remove_object(row: int, column: int):
	placed_objects[row][column] = ""

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


###[method save_to_file]:
###Saves the Garden plan to a file
###The file must already be open for writing.
#func save_to_file(file:FileAccess)->void:
#	var used_cells = get_used_cells(Layer.OBJECT)
#
#	var min_x = -1
#	var min_y = -1
#	for i in range(len(used_cells)):
#		if used_cells[i].x < min_x or min_x==-1:
#			min_x = used_cells[i].x 
#		if used_cells[i].y < min_y or min_y==-1:
#			min_y = used_cells[i].y 
#
#	var position = Vector2i(min_x,min_y)
#	var pattern = get_pattern(Layer.OBJECT,used_cells)
#
#	file.store_64(rows)
#	file.store_64(columns)
#	file.store_var(position, true)
#	file.store_var(pattern, true)
#
#
###[method save_to_file]:
###loads a Garden plan from a file
###The file must already be open for reading.
#func load_from_file(file:FileAccess)->void:
#
#	var rows = file.get_64()
#	var columns = file.get_64()
#	var position = file.get_var(true)
#	var pattern = file.get_var(true)
#
#	self.create_garden(rows,columns)
#	self.set_pattern(Layer.OBJECT,position,pattern)
