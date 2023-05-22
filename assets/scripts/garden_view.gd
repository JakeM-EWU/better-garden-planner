class_name GardenView
extends TileMap


signal tile_clicked(row: int, column: int)
signal tile_placed(row: int, column: int, key: String)
signal tile_deleted(row: int, column: int)
signal tile_moved(old_row: int, old_column: int, new_row: int, new_column: int)

enum Layer {
	GARDEN = 0,
	OBJECT = 1,
	GHOST = 2,
	UI = 3
}

# Source IDs found in Garden.tres file
const PlaceableTileSourceId = 0
const BorderSourceId = 32763
const PlaceUiCursorSourceId = 32764
const DeleteUiCursorSourceId = 32765
const MoveUiCursorSourceId = 32766

var current_edit_state = Enums.Garden_Edit_State.NONE
var _current_ui_cursor_source_id = 0

var _current_object_key: String
var _current_object_source_id = 1

var currently_moving_object: bool = false
var old_location: Vector2i
var old_source_id: int

# Called when the node enters the scene tree for the first time.
func _ready():
	GardenSignalBus.object_placed.connect( _on_object_placed)
	GardenSignalBus.object_removed.connect(_on_object_removed)
	GardenSignalBus.cleared.connect( _on_cleared)
	GardenSignalBus.size_set.connect( _on_size_set)
	pass # Replace with function body.


func _on_size_set(rows:int,columns:int):
	_generate_tiles(rows,columns)


func _on_cleared():
	clear_layer(Layer.GARDEN)
	clear_layer(Layer.OBJECT)
	clear_layer(Layer.GHOST)
	clear_layer(Layer.UI)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clear_layer(Layer.GHOST)
	clear_layer(Layer.UI)
		
	var tile = local_to_map(get_local_mouse_position())
	if (tile_is_placeable(tile)):
		match current_edit_state:
			Enums.Garden_Edit_State.PLACE:
				show_place_interface(tile)
				pass
			Enums.Garden_Edit_State.MOVE:
				show_move_interface(tile)
				pass
			Enums.Garden_Edit_State.DELETE:
				show_delete_interface(tile)
				pass
			Enums.Garden_Edit_State.NONE:
				pass


func show_place_interface(tile):
	if (tile_is_empty(tile)):
		show_ui_cursor(tile, PlaceUiCursorSourceId, Vector2(0,0))
		show_object_ghost(tile, _current_object_source_id, Vector2(0,0))
		
		if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
			var row = tile.y
			var column = tile.x
			tile_placed.emit(row, column, _current_object_key)


func show_delete_interface(tile):
	if (not tile_is_empty(tile)):
		show_ui_cursor(tile, DeleteUiCursorSourceId, Vector2(0,0))
		
		if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
			var row = tile.y
			var column = tile.x
			tile_deleted.emit(row, column)


func show_move_interface(tile):
	if (not currently_moving_object):
		
		if (not tile_is_empty(tile)):
			show_ui_cursor(tile, MoveUiCursorSourceId, Vector2(0,0))
			
			if (Input.is_action_just_pressed("Left Click")):
				currently_moving_object = true
				old_location = tile
				old_source_id = get_cell_source_id(Layer.OBJECT, tile)
				
	else:
		show_ui_cursor(old_location, MoveUiCursorSourceId, Vector2(0,0))
		
		if (tile_is_empty(tile)):
			show_ui_cursor(tile, MoveUiCursorSourceId, Vector2(0,0))
			show_object_ghost(tile, old_source_id, Vector2(0,0))
			
			if (Input.is_action_just_pressed("Left Click")):
				var old_row = old_location.y
				var old_column = old_location.x
				var new_row = tile.y
				var new_column = tile.x
				tile_moved.emit(old_row, old_column, new_row, new_column)
				currently_moving_object = false


func set_edit_state(state: Enums.Garden_Edit_State):
	current_edit_state = state
	currently_moving_object = false


func set_current_object(key: String):
	_current_object_key = key
	_current_object_source_id = JsonParser.get_sprite_source_id(key)


func show_ui_cursor(tile: Vector2i, tilemap_spritesheet_id: int, sprite_coords: Vector2):
	set_cell(Layer.UI, tile, tilemap_spritesheet_id, sprite_coords)


func show_object_ghost(tile: Vector2i, tilemap_spritesheet_id: int, sprite_coords: Vector2):
	set_cell(Layer.GHOST, tile, tilemap_spritesheet_id, sprite_coords)


##[method tile_is_empty]:
##Returns true if the location [param tile] doesn't have an object.
func tile_is_empty(tile: Vector2i) -> bool:
	var object_id = get_cell_source_id(Layer.OBJECT, tile)
	return object_id == -1


##[method tile_is_placeable]:
##Returns true if the location [param tile] can have an object placed in it.
func tile_is_placeable(tile: Vector2i) -> bool:
	var tile_source_id = get_cell_source_id(Layer.GARDEN, tile)
	return tile_source_id == PlaceableTileSourceId


##[method _generate_tiles]:
##Creates the tiles for the garden.
func _generate_tiles(rows: int, columns: int):
	for r in rows:
		for c in columns:
			set_cell(Layer.GARDEN, Vector2i(c, r), PlaceableTileSourceId, Vector2i(0,0))


func _coords_to_map(row: int, column: int) -> Vector2i:
	return Vector2i(column, row)


func _on_object_placed(row: int, column: int, object_key: String):
	var tile = _coords_to_map(row, column)
	var source_id = JsonParser.get_sprite_source_id(object_key)
	set_cell(Layer.OBJECT, tile, source_id, Vector2i(0,0))


func _on_object_removed(row: int, column: int):
	var tile = _coords_to_map(row, column)
	set_cell(Layer.OBJECT, tile, -1, Vector2i(0,0))
