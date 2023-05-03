class_name GardenPlan
extends TileMap

##The number of rows in the garden's grid.
@export var rows: int = 4
##The number of columns in the garden's grid.
@export var columns: int = 5
#The spritesheet for background tiles
var _placeable_tile_source_id = 0

var _currently_selected_source_id = 1
#The layer where background tiles are placed
var _garden_layer_id = 0
#The layer where garden objects are placed
var _object_layer_id = 1


##The height of the garden in pixels
var garden_height_in_pixels: int:
	get:
		return rows * cell_quadrant_size
##The width of the garden in pixels
var garden_width_in_pixels: int:
	get:
		return columns * cell_quadrant_size


func _ready():
	_init_garden()


#for testing purposes
func _process(delta):
	var tile = local_to_map(get_local_mouse_position())	
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		place_object(tile, _currently_selected_source_id, Vector2(0,0))


func set_source_id(id: int):
	_currently_selected_source_id = id


##[method tile_is_placeable]:
##Returns true if the location [param tile] can have an object placed in it.
func tile_is_placeable(tile: Vector2i) -> bool:
	var garden_id = get_cell_source_id(_garden_layer_id, tile)
	
	if garden_id == _placeable_tile_source_id && tile_is_empty(tile):
		return true
	return false


##[method tile_is_empty]:
##Returns true if the location [param tile] doesn't have an object.
func tile_is_empty(tile: Vector2i) -> bool:
	var object_id = get_cell_source_id(_object_layer_id, tile)

	return object_id == -1


##[method _init_garden]:
##Creates the tiles for the garden and centers it.
func _init_garden():
	_generate_tiles()
	_center_garden()


##[method _generate_tiles]:
##Creates the tiles for the garden.
func _generate_tiles():
	for r in rows:
		for c in columns:
			set_cell(_garden_layer_id, Vector2i(c, r), _placeable_tile_source_id, Vector2i(0,0))


##[method center_garden]:
##Centers the garden.
func _center_garden():
	var x_pos = (garden_width_in_pixels / 2) * -1
	var y_pos = (garden_height_in_pixels / 2) * -1
	
	self.position.x = x_pos
	self.position.y = y_pos


##[method place_object]:
##Attempts to place an object at the location [param tile].
##The sprite of the object is selected using [param tilemap_spritesheet_id] and [param sprite_coords].
##Returns [code]true[/code] if an object was placed or [code]false[/code] if not.
func place_object(tile: Vector2i, tilemap_spritesheet_id: int, sprite_coords: Vector2)->bool:
		var out = tile_is_placeable(tile)
		if 	out:
			set_cell(_object_layer_id, tile, tilemap_spritesheet_id, sprite_coords)
		return out


##[method remove_object]:
##Attempts to remove an object at the location [param tile].
##Returns [code]true[/code] if an object was removed or [code]false[/code] if not.
func remove_object(tile: Vector2i)->bool:
		var out = !tile_is_empty(tile)
		if 	out:
			set_cell(_object_layer_id, tile, -1)
		return out
