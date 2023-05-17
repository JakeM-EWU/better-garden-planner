extends Control

var save_file_dialog_scene = preload("res://assets/scenes/save_file_dialog.tscn")
var load_file_dialog_scene = preload("res://assets/scenes/load_file_dialog.tscn")

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


func _on_toggle_to_title_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/title_screen.tscn")
