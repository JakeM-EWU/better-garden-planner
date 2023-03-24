extends TileMap

@export var rows: int = 4
@export var columns: int = 5

var placeable_tile

var garden_height_in_pixels: int:
	get:
		return rows * cell_quadrant_size

var garden_width_in_pixels: int:
	get:
		return columns * cell_quadrant_size


func _ready():
	placeable_tile = tile_set.get_source_id(0)
	generate_garden()


func _process(delta):
	var tile = local_to_map(get_local_mouse_position())
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		var mouse_coords = get_local_mouse_position()
		if (cell_is_placeable(mouse_coords)):
			set_cell(1, tile, 2, Vector2(0,0))


func generate_garden():
	set_garden_size()
	center_garden()


func cell_is_placeable(coords: Vector2) -> bool:
	var tile = local_to_map(coords)
	var data = get_cell_tile_data(0, tile)
	if data:
		return data.get_custom_data("placeable")
	return false
	

func set_garden_size():
	for r in rows:
		for c in columns:
			set_cell(0, Vector2i(r, c), 0, Vector2i(0,0))


func center_garden():
	var x_pos = (garden_width_in_pixels / 2) * -1
	var y_pos = (garden_height_in_pixels / 2) * -1
	
	self.position.x = x_pos
	self.position.y = y_pos
	

