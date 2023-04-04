extends TileMap

@export var rows: int = 4
@export var columns: int = 5

var placeable_tile_source_id = 0
var test_object_source_id = 1

var garden_layer_id = 0
var object_layer_id = 1

var garden_height_in_pixels: int:
	get:
		return rows * cell_quadrant_size

var garden_width_in_pixels: int:
	get:
		return columns * cell_quadrant_size


func _ready():
	generate_garden()


func _process(delta):
	var tile = local_to_map(get_local_mouse_position())	
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and tile_is_placeable(tile)):
		place_object(tile, test_object_source_id, Vector2(0,0))


func tile_is_placeable(tile: Vector2i) -> bool:
	var data = get_cell_tile_data(0, tile)
	if data:
		return data.get_custom_data("placeable")
	return false
	

func generate_garden():
	set_garden_size()
	center_garden()


func set_garden_size():
	for r in rows:
		for c in columns:
			set_cell(garden_layer_id, Vector2i(r, c), placeable_tile_source_id, Vector2i(0,0))


func center_garden():
	var x_pos = (garden_width_in_pixels / 2) * -1
	var y_pos = (garden_height_in_pixels / 2) * -1
	
	self.position.x = x_pos
	self.position.y = y_pos
	


func place_object(tile: Vector2i, tilemap_spritesheet_id: int, sprite_coords: Vector2):
		set_cell(object_layer_id, tile, tilemap_spritesheet_id, sprite_coords)
	
