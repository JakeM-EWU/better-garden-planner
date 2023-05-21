extends Node

signal object_place_requested(row:int,column,object_key:String)
signal object_remove_requested(row:int,column:int)
signal object_move_requested(old_row:int, old_column:int, new_row:int, new_column:int)
signal object_select_requested(row:int,column:int)
signal load_file_requested()
signal save_file_requested()
signal exit_program_requested()

@onready var _garden_view = $"Garden View"
var save_file_dialog_scene = preload("res://assets/scenes/save_file_dialog.tscn")
var load_file_dialog_scene = preload("res://assets/scenes/load_file_dialog.tscn")

var current_key: String = ""
var current_action: Tile_Action = Tile_Action.NONE

enum Tile_Action{
	PLACE,
	DELETE,
	MOVE,
	NONE,
}

enum File_Menu_Option{
	EXIT = 1,
	CREATE_GARDEN = 2,
	SAVE_AS = 3,
	LOAD = 4,
}

enum Edit_Menu_Option {
	PLACE = 0,
	DELETE = 1,
	MOVE = 2,
}

func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		$"Menu/VBoxContainer/HBoxContainer/Object Library".hide()
		$"Menu/VBoxContainer/MenuBarPanel/MenuBar/Action State Label".text = ""


##[method _on_file_id_pressed]:
##Connected to the file menu's [signal PopupMenu.index_pressed]
func _on_file_id_pressed(id):
	match id:
		File_Menu_Option.EXIT:
			exit_program_requested.emit()
		#File_Menu_Options.CREATE_GARDEN:
			#var garden_creation_popup = _garden_creation_popup_scene.instantiate()
			#self.add_child(garden_creation_popup)
		File_Menu_Option.SAVE_AS:
			save_file_requested.emit()
		File_Menu_Option.LOAD:
			load_file_requested.emit()
		_:
			push_warning("Menu Item not found")


func prompt_load_file()->String:
	#create and display the file dialog
	var load_file_dialag = load_file_dialog_scene.instantiate()
	load_file_dialag.show()
	self.add_child(load_file_dialag)
	
	#wait for the user's selection
	var output = await(load_file_dialag.file_selected_or_cancelled)
	load_file_dialag.queue_free()
	return output

func prompt_save_file()->String:
	#create and display the file dialog
	var save_file_dialog = save_file_dialog_scene.instantiate()
	save_file_dialog.show()
	self.add_child(save_file_dialog)
	
	#wait for the user's selection
	var output = await(save_file_dialog.file_selected_or_cancelled)
	save_file_dialog.queue_free()
	return output
	

func _on_object_library_object_selected(object_name: String):
	print(object_name)
	var selected_id = JsonParser.get_sprite_source_id(object_name)
	current_key = object_name
	_garden_view.set_currently_selected_source_id(selected_id)


func _on_garden_view_tile_clicked(row: int, column: int):
	match current_action:
		Tile_Action.PLACE:
			object_place_requested.emit(row, column, current_key)
			print(current_key)
		Tile_Action.MOVE:
			pass
		Tile_Action.DELETE:
			pass
		Tile_Action.NONE:
			pass


func _on_toggle_to_title_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/title_screen.tscn")


func _on_edit_id_pressed(id):
	match id:
		Edit_Menu_Option.PLACE:
			print("Place me")
			current_action = Tile_Action.PLACE
			$"Menu/VBoxContainer/HBoxContainer/Object Library".show()
			$"Menu/VBoxContainer/MenuBarPanel/MenuBar/Action State Label".text = "In place mode - Press ESC to cancel"
		Edit_Menu_Option.DELETE:
			print("Delete me")
			$"Menu/VBoxContainer/MenuBarPanel/MenuBar/Action State Label".text = "In delete mode - Press ESC to cancel"
		Edit_Menu_Option.MOVE:
			print("Move me")
			$"Menu/VBoxContainer/MenuBarPanel/MenuBar/Action State Label".text = "In move mode - Press ESC to cancel"
		
	pass # Replace with function body.
