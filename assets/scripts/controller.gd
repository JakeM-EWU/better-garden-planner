extends Node

func _on_file_id_pressed(id):
	match  id:
		1:
			get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit()
		_:
			push_warning("Menu Item not found")
