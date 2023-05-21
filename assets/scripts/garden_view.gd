class_name GardenView
extends TileMap


signal tile_clicked(row: int, column: int)

#The spritesheet for background tiles
var _placeable_tile_source_id = 0

var _place_ui_cursor_source_id = 32764
var _delete_ui_cursor_source_id = 32765
var _move_ui_cursor_source_id = 32766



enum Layer {
	GARDEN = 0,
	OBJECT = 1,
	GHOST = 2,
	UI = 3
}

var _current_ui_cursor_source_id = 0
var _current_object_source_id = 1
var current_edit_state = Enums.Garden_Edit_State.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	GardenSignalBus.object_placed.connect( _on_object_placed)
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
	if (current_edit_state != Enums.Garden_Edit_State.NONE):
		
		if (tile_is_placeable(tile)):
			set_cell(Layer.UI, tile, _current_ui_cursor_source_id, Vector2(0,0))
			
			if (current_edit_state == Enums.Garden_Edit_State.PLACE):
				show_ghost(tile, _current_object_source_id, Vector2(0,0))
				
		if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
			var row = tile.y
			var column = tile.x
			emit_signal("tile_clicked", row, column)


func set_edit_state(state: Enums.Garden_Edit_State):
	current_edit_state = state
	match state:
		Enums.Garden_Edit_State.PLACE:
			_current_ui_cursor_source_id = _place_ui_cursor_source_id
		Enums.Garden_Edit_State.MOVE:
			_current_ui_cursor_source_id = _move_ui_cursor_source_id
		Enums.Garden_Edit_State.DELETE:
			_current_ui_cursor_source_id = _delete_ui_cursor_source_id

func set_currently_selected_source_id(id: int):
	_current_object_source_id = id


func show_ghost(tile: Vector2i, tilemap_spritesheet_id: int, sprite_coords: Vector2):
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
	return tile_source_id == _placeable_tile_source_id


##[method _generate_tiles]:
##Creates the tiles for the garden.
func _generate_tiles(rows: int, columns: int):
	for r in rows:
		for c in columns:
			set_cell(Layer.GARDEN, Vector2i(c, r), _placeable_tile_source_id, Vector2i(0,0))


func _coords_to_map(row: int, column: int) -> Vector2i:
	return Vector2i(column, row)


func _on_object_placed(row: int, column: int, object_key: String):
	var tile = _coords_to_map(row, column)
	var source_id = JsonParser.get_sprite_source_id(object_key)
	set_cell(Layer.OBJECT, tile, source_id, Vector2i(0,0))
