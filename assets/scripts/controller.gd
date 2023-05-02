class_name Controller
extends Node


var _garden_scene = preload("res://assets/scenes/Garden.tscn")
var _garden_creation_popup_scene = preload("res://assets/scenes/garden_creation_popup.tscn")
var _garden
var _garden_plan:GardenPlan

enum File_Menu_Options {
	EXIT = 1,
	CREATE_GARDEN = 2,
}

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
	_garden_plan.rows=rows
	_garden_plan.columns=columns
	add_child(_garden)

#for testing
func _ready():
	create_garden(4,4)
	_garden_plan.place_object(Vector2i(1,2),1,Vector2i(0,0))
	_garden_plan.place_object(Vector2i(2,2),1,Vector2i(3,0))

