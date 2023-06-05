extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



# placeholder for toggling from the title screen to the UI screen
func _on_jump_to_ui_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/Controller.tscn")
	pass # Replace with function body.


func _on_load_button_pressed():
	var node = get_node("load_file_dialog")
	node.visible = true
