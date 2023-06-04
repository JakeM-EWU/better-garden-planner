extends Camera2D

const MinZoom: float = 0.1
const MaxZoom: float = 1.5
const ZoomIncrement: float = 0.1

var _current_zoom: float = 1.0
var x_bounds = 0.0
var y_bounds = 0.0

func _ready():
	GardenSignalBus.size_set.connect(_on_size_set)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			var new_position = position - (event.relative / _current_zoom)
			var x = clampf(new_position.x, -x_bounds, x_bounds)
			var y = clampf(new_position.y, -y_bounds, y_bounds)
			position = Vector2(x, y)
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_current_zoom = max(_current_zoom - ZoomIncrement, MinZoom)
				self.zoom = _current_zoom * Vector2.ONE
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_current_zoom = min(_current_zoom + ZoomIncrement, MaxZoom)
				self.zoom = _current_zoom * Vector2.ONE
		print(zoom)


func _on_size_set(rows: int, columns: int):
	x_bounds = (columns / 2) * 32	
	y_bounds = (rows / 2) * 32
