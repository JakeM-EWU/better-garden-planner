class_name Garden
extends Node

var rows: int
var columns: int
var placed_objects: Array


func create_garden(rows: int, columns: int) -> void:
	$NotebookData.update_notebook_data({})
	GardenSignalBus.size_set.emit(rows,columns)
	self.rows = rows
	self.columns = columns
	for r in rows:
		placed_objects.append([])
		for c in columns:
			placed_objects[r].append("")


func place_object(row: int, column: int, object_key: String):
	placed_objects[row][column] = object_key
	GardenSignalBus.object_placed.emit(row, column, object_key)


func remove_object(row: int, column: int):
	placed_objects[row][column] = ""
	GardenSignalBus.object_removed.emit(row, column)


func move_object(old_row: int, old_column: int, row: int, column: int):
	var temp = placed_objects[old_row][old_column]
	remove_object(old_row, old_column)
	place_object(row, column, temp)


##[method save_to_file]:
##Saves the Garden to a file
##The file must already be open for writing.
#For now this only saves the garden plan, but it can be extended
#to save other parts of a project
func save_to_file(file:FileAccess):
	file.store_64(rows)
	file.store_64(columns)
	file.store_var(placed_objects,true)
	$NotebookData.save_to_file(file)

##[method load_from_file]:
##Loads a Garden from a file. 
##The file must already be open for reading.
#For now this only loads the garden plan, but it can be extended
#to load other parts of a project
func load_from_file(file:FileAccess):
	GardenSignalBus.cleared.emit()
	
	rows = file.get_64()
	columns = file.get_64()
	placed_objects= file.get_var(true)
	
	GardenSignalBus.size_set.emit(rows,columns)
	
	for r in range(rows):
		for c in range(columns):
			if not placed_objects[r][c].is_empty():
				GardenSignalBus.object_placed.emit(r,c,placed_objects[r][c])

	$NotebookData.load_from_file(file)


func show_garden_details(placed_objects):
	GardenSignalBus.show_garden_details.emit(placed_objects)


func get_placed_objects():
	GardenSignalBus.get_placed_objects.emit(placed_objects)
