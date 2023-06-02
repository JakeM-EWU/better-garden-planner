class_name Controller
extends Node


const UserProjectsDirectory: String = "user://projects"

var _garden_creation_popup_scene = preload("res://assets/scenes/garden_creation_popup.tscn")

@onready var _ui: Ui = $UI

@onready var _garden_data: Garden = $Garden

func _ready():
	connect_ui_signals()
	# this if statement creates a save folder if one does not already exist
	if(not DirAccess.dir_exists_absolute(UserProjectsDirectory)):
		var project_folder_creation_error = DirAccess.make_dir_absolute(UserProjectsDirectory)
		if(project_folder_creation_error !=OK):
			printerr("Couldn't create the project folder to save files. Error is below")
			printerr(error_string(project_folder_creation_error))
	# this code is for testing. Makes a garden with(up to) 10 random plants in random locations.
	# create_garden(10,10)
	# for i in range(10):
		# var sprite_coord = Vector2i(randi_range(0,38),randi_range(0,6))
		# var tile = Vector2i(randi_range(0,10),randi_range(0,10))
		
		# _garden_plan.place_object(tile,1,sprite_coord)



func connect_ui_signals():
	_ui.object_place_requested.connect(_on_object_place_requested)
	_ui.object_remove_requested.connect(_on_object_remove_requested)
	_ui.object_move_requested.connect(_on_object_move_requested)
	_ui.load_file_requested.connect(_on_load_requested)
	_ui.save_file_requested.connect(_on_save_requested)
	_ui.exit_program_requested.connect(_on_exit_program_requested)
	_ui.notebook_update_requested.connect(_on_notebook_update_requested)
	_ui.create_garden_requested.connect(_on_create_garden_requested)
	_ui.export_image_requested.connect(_on_export_image_requested)


func _on_object_place_requested(row:int,column:int,object_key:String):
	_garden_data.place_object(row,column,object_key)


func _on_object_remove_requested(row:int, column:int):
	_garden_data.remove_object(row, column)
	pass

func _on_create_garden_requested(rows,columns):
	create_garden(rows,columns)

func _on_object_move_requested(old_row: int, old_column: int, row: int, column: int):
	_garden_data.move_object(old_row, old_column, row, column)

func _on_load_requested():
	var path:String = await(_ui.prompt_load_file())
	if !path.is_empty():
		open_file_and_load(path)


func _on_save_requested():
	var path = await(_ui.prompt_save_file())
	open_file_and_save(path)


func _on_exit_program_requested():
	get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
	
	
func _on_export_image_requested():
	_ui.set_menu_visibility(false)
	
	await get_tree().create_timer(0.02).timeout
	
	var image = get_viewport().get_texture().get_image()
	var file_path: String = "{d}/{n}.png".format(
			{
			"d": UserProjectsDirectory, 
			"n": Time.get_date_string_from_system()
			})
	image.save_png(file_path)
	
	_ui.set_menu_visibility(true)
	_ui.show_image_message(file_path)


##[method create_garden]:
##Creates a [param rows] by [param columns] garden scene and adds it to the tree
func create_garden(rows:int, columns:int):
	_garden_data.create_garden(rows, columns)


##[method create_and_load_garden]:
##loads a garden from [param file].
#TODO deal with errors in this clause.
func create_and_load_garden(file:FileAccess):
	_garden_data.load_from_file(file)


##[method save_garden]:
##Attempts to save a garden to [param file].
##If there is no garden currently open. Nothing is saved, it returns an error message.
##Otherwise it returns OK.
func save_garden(file:FileAccess):
	if _garden_data == null:
		return ERR_DOES_NOT_EXIST
	_garden_data.save_to_file(file)
	return OK


##[method open_file_and_load]:
##Attempts to save a garden at the path [param path].
##If there is no garden currently open. Nothing is saved, it prints an error message.
##May return an error in the future to allow for an error popup.
##Returns nothing.
func open_file_and_load(path:String):

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

func _on_notebook_update_requested(new_notebook_state:Dictionary):
	$Garden/NotebookData.update_notebook_data(new_notebook_state)
