extends Node
var _file_menu_exit_id:int=1
var _garden_scene = preload("res://assets/scenes/Garden.tscn")
var _garden
##[method _on_file_id_pressed]:
##Connected to the file menu's [signal PopupMenu.index_pressed]
func _on_file_id_pressed(id):
	match  id:
		_file_menu_exit_id:
			get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit()
		_:
			push_warning("Menu Item not found")
##[method create_garden]:
##Creates a garden scene and adds it to the tree
func create_garden(rows:int, columns:int):
	_garden = _garden_scene.instantiate()
	_garden.get_child(0).rows=rows
	_garden.get_child(0).columns=columns
	add_child(_garden)

#for testing
func _ready():
	create_garden(4,4)
	_garden.get_child(0).place_object(Vector2i(1,2),1,Vector2i(0,0))
	_garden.get_child(0).place_object(Vector2i(2,2),1,Vector2i(3,0))

