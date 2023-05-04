class_name Controller
extends Node

enum File_Menu_Options {
	EXIT = 1,
	CREATE_GARDEN = 2,
}

var _garden_scene = preload("res://assets/scenes/garden.tscn")
var _garden_creation_popup_scene = preload("res://assets/scenes/garden_creation_popup.tscn")
var _garden
var _garden_plan:GardenPlan
@onready var _ui = $CanvasLayer/UI

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
			
		_:
			push_warning("Menu Item not found")


##[method create_garden]:
##Creates a garden scene and adds it to the tree
func create_garden(rows:int, columns:int):
	_garden = _garden_scene.instantiate()
	_garden_plan = _garden.get_node("GardenPlan")
	_garden_plan.create_garden(rows, columns)
	add_child(_garden)
	
func create_and_load_garden(file:FileAccess):
	_garden = _garden_scene.instantiate()
	_garden_plan = _garden.get_node("GardenPlan")
	_garden.load_from_file(file)
	add_child(_garden)

func save_garden(file:FileAccess):
	if _garden == null:
		return ERR_DOES_NOT_EXIST
	_garden.save_to_file(file)
	add_child(_garden)
	
	
func open_file_and_load(file_name:String):
	var file = FileAccess.open(file_name,FileAccess.READ)
	var open_error = FileAccess.get_open_error()
	if open_error != OK:
		printerr(error_string(open_error))
	else:
		create_and_load_garden(file)
		var error = file.get_error()
		if error:
			printerr(error_string(error))
		file.close()

func open_file_and_save(file_name:String):
	var file = FileAccess.open(file_name,FileAccess.WRITE)
	var open_error = FileAccess.get_open_error()
	if open_error != OK:
		printerr(error_string(open_error))
	else:
		save_garden(file)
		var error = file.get_error()
		if error:
			printerr(error_string(error))
		file.close()


func _ready():
	# this if statement creates a save folder if one does not already exist
	if(not DirAccess.dir_exists_absolute("user://projects")):
		var project_folder_creation_error = DirAccess.make_dir_absolute("user://projects")
		if(project_folder_creation_error !=OK):
			printerr("Couldn't create the project folder to save files. Error is below")
			printerr(error_string(project_folder_creation_error))

	# this code is for testing
	var str = await(_ui.prompt_save_file())
	print("User selected:",str)
	
	str = await(_ui.prompt_load_file())
	print("User selected:",str)
