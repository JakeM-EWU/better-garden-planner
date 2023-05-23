extends Camera2D

const MIN_ZOOM: float = 0.1
const MAX_ZOOM: float = 1.0
const ZOOM_INCREMENT: float = 0.1
const ZOOM_RATE: float = 8.0

var _target_zoom: float = 1.0

func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			position -= event.relative
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
				self.zoom = _target_zoom * Vector2.ONE
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_target_zoom = max(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
				self.zoom = _target_zoom * Vector2.ONE
			

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
