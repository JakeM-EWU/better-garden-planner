extends Camera2D

const MIN_ZOOM: float = 0.1
const MAX_ZOOM: float = 1.0
const ZOOM_INCREMENT: float = 0.1

var _current_zoom: float = 1.0

func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			position -= event.relative / _current_zoom
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_current_zoom = max(_current_zoom - ZOOM_INCREMENT, MIN_ZOOM)
				self.zoom = _current_zoom * Vector2.ONE
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_current_zoom = max(_current_zoom + ZOOM_INCREMENT, MAX_ZOOM)
				self.zoom = _current_zoom * Vector2.ONE

