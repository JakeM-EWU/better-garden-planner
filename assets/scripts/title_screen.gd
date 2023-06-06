extends Control


signal prompt_create_garden_reqeusted
signal prompt_load_garden_reqeusted

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_button_pressed():
	prompt_create_garden_reqeusted.emit()
	
func _on_load_button_pressed():
	prompt_load_garden_reqeusted.emit()
