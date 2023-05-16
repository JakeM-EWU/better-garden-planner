class_name GardenPlan
extends TileMap


##The number of rows in the garden's grid.
@export var rows: int = 4
##The number of columns in the garden's grid.
@export var columns: int = 5
#The spritesheet for background tiles
var _placeable_tile_source_id = 0


var _currently_selected_source_id = 1

##The height of the garden in pixels
var garden_height_in_pixels: int:
	get:
		return rows * cell_quadrant_size
##The width of the garden in pixels
var garden_width_in_pixels: int:
	get:
		return columns * cell_quadrant_size

enum Layer {
	GARDEN = 0,
	OBJECT = 1,
	GHOST = 2,
}


func create_garden(rows:int, columns: int)->void:
	self.rows = rows
	self.columns = columns
	_generate_tiles()
	_center_garden()



#for testing purposes
func _process(delta):
	var tile = local_to_map(get_local_mouse_position())	
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		place_object(tile, _currently_selected_source_id, Vector2(0,0))
	clear_layer(Layer.GHOST)
	if (tile_is_placeable(tile)):
		show_ghost(tile, _currently_selected_source_id, Vector2(0,0))
	


func set_source_id(id: int):
	_currently_selected_source_id = id

##[method place_object]:
##Attempts to place an object at the location [param tile].
##The sprite of the object is selected using [param tilemap_spritesheet_id] and [param sprite_coords].
##Returns [code]true[/code] if an object was placed or [code]false[/code] if not.
func place_object(tile: Vector2i, tilemap_spritesheet_id: int, sprite_coords: Vector2)->bool:
		var out = tile_is_placeable(tile)
		if 	out:
			set_cell(Layer.OBJECT, tile, tilemap_spritesheet_id, sprite_coords)
		return out


##[method remove_object]:
##Attempts to remove an object at the location [param tile].
##Returns [code]true[/code] if an object was removed or [code]false[/code] if not.
func remove_object(tile: Vector2i)->bool:
		var out = !tile_is_empty(tile)
		if 	out:
			set_cell(Layer.OBJECT, tile, -1)
		return out


func show_ghost(tile: Vector2i, tilemap_spritesheet_id: int, sprite_coords: Vector2):
	set_cell(Layer.GHOST, tile, tilemap_spritesheet_id, sprite_coords)


##[method tile_is_placeable]:
##Returns true if the location [param tile] can have an object placed in it.
func tile_is_placeable(tile: Vector2i) -> bool:

	var garden_id = get_cell_source_id(Layer.GARDEN, tile)

	
	if garden_id == _placeable_tile_source_id && tile_is_empty(tile):
		return true
	return false


##[method tile_is_empty]:
##Returns true if the location [param tile] doesn't have an object.
func tile_is_empty(tile: Vector2i) -> bool:

	var object_id = get_cell_source_id(Layer.OBJECT, tile)

	return object_id == -1


##[method _generate_tiles]:
##Creates the tiles for the garden.
func _generate_tiles():
	for r in rows:
		for c in columns:

			set_cell(Layer.GARDEN, Vector2i(c, r), _placeable_tile_source_id, Vector2i(0,0))



##[method center_garden]:
##Centers the garden.
func _center_garden():
	var x_pos = (garden_width_in_pixels / 2) * -1
	var y_pos = (garden_height_in_pixels / 2) * -1
	
	self.position.x = x_pos
	self.position.y = y_pos



##[method save_to_file]:
##Saves the Garden plan to a file
##The file must already be open for writing.
func save_to_file(file:FileAccess)->void:
	var used_cells = get_used_cells(Layer.OBJECT)
	
	var min_x = -1
	var min_y = -1
	for i in range(len(used_cells)):
		if used_cells[i].x < min_x or min_x==-1:
			min_x = used_cells[i].x 
		if used_cells[i].y < min_y or min_y==-1:
			min_y = used_cells[i].y 
			
	var position = Vector2i(min_x,min_y)
	var pattern = get_pattern(Layer.OBJECT,used_cells)
	
	file.store_64(rows)
	file.store_64(columns)
	file.store_var(position, true)
	file.store_var(pattern, true)
	

##[method save_to_file]:
##loads a Garden plan from a file
##The file must already be open for reading.
func load_from_file(file:FileAccess)->void:
	
	var rows = file.get_64()
	var columns = file.get_64()
	var position = file.get_var(true)
	var pattern = file.get_var(true)
	
	self.create_garden(rows,columns)
	self.set_pattern(Layer.OBJECT,position,pattern)
