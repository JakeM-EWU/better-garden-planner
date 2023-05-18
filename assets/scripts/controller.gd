class_name Controller
extends Node

enum File_Menu_Options {
	EXIT = 1,
	CREATE_GARDEN = 2,
	SAVE_AS = 3,
	LOAD = 4,
}

var _garden_scene = preload("res://assets/scenes/garden.tscn")
var _garden_creation_popup_scene = preload("res://assets/scenes/garden_creation_popup.tscn")
var _garden
var _garden_plan:GardenPlan
@onready var _ui = $CanvasLayer/UI

@onready var _garden_view: GardenView = $"CanvasLayer/UI/Garden View"

##[method _on_file_id_pressed]:
##Connected to the file menu's [signal PopupMenu.index_pressed]
func _on_file_id_pressed(id):
	match id:
		File_Menu_Options.EXIT:
			get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit()
		#File_Menu_Options.CREATE_GARDEN:
			#var garden_creation_popup = _garden_creation_popup_scene.instantiate()
			#self.add_child(garden_creation_popup)
		File_Menu_Options.SAVE_AS:
			var path = await(_ui.prompt_save_file())
			open_file_and_save(path)
		File_Menu_Options.LOAD:
			var path:String = await(_ui.prompt_load_file())
			if !path.is_empty():
				open_file_and_load(path)
		_:
			push_warning("Menu Item not found")


##[method create_garden]:
##Creates a [param rows] by [param columns] garden scene and adds it to the tree
func create_garden(rows:int, columns:int):
	_garden = _garden_scene.instantiate()
	_garden_plan = _garden.get_node("GardenPlan")
	_garden_plan.create_garden(rows, columns)
	add_child(_garden)


##[method create_and_load_garden]:
##loads a garden from [param file].
#TODO deal with errors in this clause.
func create_and_load_garden(file:FileAccess):
	_garden = _garden_scene.instantiate()
	add_child(_garden)
	_garden_plan = _garden.get_node("GardenPlan")
	_garden.load_from_file(file)


##[method save_garden]:
##Attempts to save a garden to [param file].
##If there is no garden currently open. Nothing is saved, it returns an error message.
##Otherwise it returns OK.
func save_garden(file:FileAccess):
	if _garden == null:
		return ERR_DOES_NOT_EXIST
	_garden.save_to_file(file)
	return OK


##[method open_file_and_load]:
##Attempts to save a garden at the path [param path].
##If there is no garden currently open. Nothing is saved, it prints an error message.
##May return an error in the future to allow for an error popup.
##Returns nothing.
func open_file_and_load(path:String):
	if _garden != null:
		_garden.queue_free()
		_garden = null

	var file = FileAccess.open(path,FileAccess.READ)
	var open_error = FileAccess.get_open_error()
	if open_error != OK:
		printerr(error_string(open_error))
	else:
		create_and_load_garden(file)
		var error = file.get_error()
		if error:
			printerr(error_string(error))
		file.close()

## [method open_file_and_save]:
## Attempts to save a garden at the path [param path].
## If there is no garden currently open. Nothing is saved, it prints an error message.
## May return an error in the future to allow for an error popup.
## Returns nothing.
func open_file_and_save(path:String):
	if _garden !=  null:
		var file = FileAccess.open(path,FileAccess.WRITE)
		var open_error = FileAccess.get_open_error()
		if open_error != OK:
			printerr(error_string(open_error))
		else:
			save_garden(file)
			var error = file.get_error()
			if error:
				printerr(error_string(error))
			file.close()
	else:
		#might be better to make a popup for this error.
		printerr("Can't save a non-existant garden")

func _ready():
	# this if statement creates a save folder if one does not already exist
	if(not DirAccess.dir_exists_absolute("user://projects")):
		var project_folder_creation_error = DirAccess.make_dir_absolute("user://projects")
		if(project_folder_creation_error !=OK):
			printerr("Couldn't create the project folder to save files. Error is below")
			printerr(error_string(project_folder_creation_error))
	$"CanvasLayer/UI/Menu/VBoxContainer/HBoxContainer/LeftBarPanel/TabContainer/Object Library".connect("object_selected", _on_object_selected)
	# this code is for testing. Makes a garden with(up to) 10 random plants in random locations.
	# create_garden(10,10)
	# for i in range(10):
		# var sprite_coord = Vector2i(randi_range(0,38),randi_range(0,6))
		# var tile = Vector2i(randi_range(0,10),randi_range(0,10))
		
		# _garden_plan.place_object(tile,1,sprite_coord)


func _on_object_selected(object_name: String):
	print(object_name)
	var selected_id = JsonParser.get_sprite_source_id(object_name)
	_garden_view.set_currently_selected_source_id(selected_id)
	
