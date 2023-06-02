class_name Ui
extends Node

signal object_place_requested(row: int, column, object_key: String)
signal object_remove_requested(row: int, column: int)
signal object_move_requested(old_row: int, old_column: int, new_row: int, new_column: int)
signal object_select_requested(row: int,column: int)
signal load_file_requested()
signal save_file_requested()
signal export_image_requested()
signal exit_program_requested()
signal get_placed_objects_requested()

##[signal notebook_update_requested] emmited when the UI wants to update
##the backend representation of a notebook. emits a dictionary representing
##the new state of the notebook.
signal notebook_update_requested(new_notebook_state:Dictionary)

enum File_Menu_Option{
	EXIT = 1,
	CREATE_GARDEN = 2,
	SAVE_AS = 3,
	LOAD = 4,
	EXPORT_IMAGE = 5,
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


@onready var _garden_view: GardenView = $"Garden View"
@onready var _object_library: ObjectLibrary = $"CanvasLayer/Menu/VBoxContainer/HBoxContainer/Object Library"
@onready var _action_state_label: Label = $"CanvasLayer/Menu/VBoxContainer/MenuBarPanel/MenuBar/Action State Label"
@onready var _garden_inventory_popup = $CanvasLayer/Menu/VBoxContainer/HBoxContainer/garden_inventory_popup
@onready var _garden_schedule_popup = $CanvasLayer/Menu/VBoxContainer/HBoxContainer/garden_schedule_popup


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
		#File_Menu_Option.CREATE_GARDEN:
			#var garden_creation_popup = _garden_creation_popup_scene.instantiate()
			#self.add_child(garden_creation_popup)
		File_Menu_Option.SAVE_AS:
			save_file_requested.emit()
		File_Menu_Option.LOAD:
			load_file_requested.emit()
		File_Menu_Option.EXPORT_IMAGE:
			export_image_requested.emit()
		_:
			push_warning("Menu Item not found")


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
	_garden_inventory_popup.hide()
	_garden_schedule_popup.hide()
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
			get_placed_objects_requested.emit()
			_garden_inventory_popup.visible = true

		View_Menu_Option.SCHEDULE:
			get_placed_objects_requested.emit()
			_garden_schedule_popup.visible = true


func _on_help_id_pressed(id):
	pass # Replace with function body.
