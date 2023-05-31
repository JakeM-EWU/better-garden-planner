class_name Ui
extends Node

signal object_place_requested(row: int, column, object_key: String)
signal object_remove_requested(row: int, column: int)
signal object_move_requested(old_row: int, old_column: int, new_row: int, new_column: int)
signal object_select_requested(row: int,column: int)
signal load_file_requested()
signal save_file_requested()
signal exit_program_requested()
##[signal notebook_update_requested] emmited when the UI wants to update
##the backend representation of a notebook. emits a dictionary representing
##the new state of the notebook.
signal notebook_update_requested(new_notebook_state:Dictionary)
signal create_garden_requested(rows:int, columns:int)

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

enum View_Menu_Option {
	INVENTORY = 0,
	SCHEDULE = 1,
}

const SaveFileDialogScene = preload("res://assets/scenes/save_file_dialog.tscn")
const LoadFileDialogScene = preload("res://assets/scenes/load_file_dialog.tscn")
const GardenCreationPopupScene = preload("res://assets/scenes/garden_creation_popup.tscn")



@onready var _garden_view: GardenView = $"Garden View"
@onready var _object_library: ObjectLibrary = $"Menu/VBoxContainer/HBoxContainer/Object Library"
@onready var _action_state_label: Label = $"Menu/VBoxContainer/MenuBarPanel/MenuBar/Action State Label"


func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		_reset_view()


##[method _on_file_id_pressed]:
##Connected to the file menu's [signal PopupMenu.index_pressed]
func _on_file_id_pressed(id):
	_reset_view()
	match id:
		File_Menu_Option.EXIT:
			exit_program_requested.emit()
		File_Menu_Option.CREATE_GARDEN:
			prompt_create_garden()
		File_Menu_Option.SAVE_AS:
			save_file_requested.emit()
		File_Menu_Option.LOAD:
			load_file_requested.emit()
		_:
			push_warning("Menu Item not found")

##[method prompt_create_garden] prompts the user to create a garden with 
##a dialog box
func prompt_create_garden():
	var garden_creation_popup = GardenCreationPopupScene.instantiate()
	self.add_child(garden_creation_popup)
	var dimensions = await(garden_creation_popup.dimensions_selected_or_cancelled)
	var rows = dimensions[1]
	var columns = dimensions[0]
	if rows > 0 and columns > 0:
		create_garden_requested.emit(rows,columns)
	garden_creation_popup.queue_free()
	
func prompt_load_file()->String:
	#create and display the file dialog
	var load_file_dialag = LoadFileDialogScene.instantiate()
	load_file_dialag.show()
	self.add_child(load_file_dialag)
	
	#wait for the user's selection
	var output = await(load_file_dialag.file_selected_or_cancelled)
	load_file_dialag.queue_free()
	return output


func prompt_save_file()->String:
	#create and display the file dialog
	var save_file_dialog = SaveFileDialogScene.instantiate()
	save_file_dialog.show()
	self.add_child(save_file_dialog)
	
	#wait for the user's selection
	var output = await(save_file_dialog.file_selected_or_cancelled)
	save_file_dialog.queue_free()
	return output


func _on_object_library_object_selected(object_name: String):
	_garden_view.set_current_object(object_name)


func _on_edit_id_pressed(id):
	_reset_view()
	match id:
		Edit_Menu_Option.PLACE:
			_object_library.show()
			_object_library.select_first_item()
			_action_state_label.text = "In place mode - Press ESC to cancel"
			_garden_view.set_edit_state(Enums.Garden_Edit_State.PLACE)
		Edit_Menu_Option.DELETE:
			_action_state_label.text = "In delete mode - Press ESC to cancel"
			_garden_view.set_edit_state(Enums.Garden_Edit_State.DELETE)
		Edit_Menu_Option.MOVE:
			_action_state_label.text = "In move mode - Press ESC to cancel"
			_garden_view.set_edit_state(Enums.Garden_Edit_State.MOVE)
	pass # Replace with function body.


func _reset_view():
	$Menu/VBoxContainer/HBoxContainer/garden_inventory_popup.hide()
	$Menu/VBoxContainer/HBoxContainer/garden_schedule_popup.hide()
	_object_library.hide()
	_action_state_label.text = ""
	_garden_view.set_edit_state(Enums.Garden_Edit_State.NONE)


func _on_garden_view_tile_deleted(row, column):
	object_remove_requested.emit(row,column)	
	pass # Replace with function body.


func _on_garden_view_tile_moved(old_row, old_column, new_row, new_column):
	object_move_requested.emit(old_row, old_column, new_row, new_column)
	pass # Replace with function body.


func _on_garden_view_tile_placed(row, column, key):
	object_place_requested.emit(row, column, key)
	pass # Replace with function body.


##[method _on_view_id_pressed]:
##Connected to the view menu's [signal PopupMenu.index_pressed]
func _on_view_id_pressed(id):
	_reset_view()
	match id:
		View_Menu_Option.INVENTORY:
			$Menu/VBoxContainer/HBoxContainer/garden_inventory_popup.visible = true
			
		View_Menu_Option.SCHEDULE:
			$Menu/VBoxContainer/HBoxContainer/garden_schedule_popup.visible = true
