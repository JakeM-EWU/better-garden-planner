extends Node
var _file_menu_exit_id:int=1

##[method _on_file_id_pressed]:
##Connected to the file menu's [signal PopupMenu.index_pressed]
func _on_file_id_pressed(id):
	match  id:
		_file_menu_exit_id:
			get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit()
		_:
			push_warning("Menu Item not found")
