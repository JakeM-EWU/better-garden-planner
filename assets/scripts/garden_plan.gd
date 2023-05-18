class_name GardenPlan
extends TileMap


##The number of rows in the garden's grid.
@export var rows: int = 4
##The number of columns in the garden's grid.
@export var columns: int = 5


var placed_objects: Array


func create_garden(rows: int, columns: int) -> void:
	self.rows = rows
	self.columns = columns
	for r in rows:
		placed_objects.append([])
		for c in columns:
			placed_objects[r].append("")


func _ready():
	pass

#for testing purposes
func _process(delta):
	pass
	




##[method place_object]:
##Attempts to place an object at the location [param tile].
##The sprite of the object is selected using [param tilemap_spritesheet_id] and [param sprite_coords].
##Returns [code]true[/code] if an object was placed or [code]false[/code] if not.
#func place_object(tile: Vector2i, tilemap_spritesheet_id: int, sprite_coords: Vector2)->bool:
#		var out = tile_is_placeable(tile)
#		if 	out:
#			set_cell(Layer.OBJECT, tile, tilemap_spritesheet_id, sprite_coords)
#		return out


##[method remove_object]:
##Attempts to remove an object at the location [param tile].
##Returns [code]true[/code] if an object was removed or [code]false[/code] if not.
#func remove_object(tile: Vector2i)->bool:
#		var out = !tile_is_empty(tile)
#		if 	out:
#			set_cell(Layer.OBJECT, tile, -1)
#		return out







###[method save_to_file]:
###Saves the Garden plan to a file
###The file must already be open for writing.
#func save_to_file(file:FileAccess)->void:
#	var used_cells = get_used_cells(Layer.OBJECT)
#
#	var min_x = -1
#	var min_y = -1
#	for i in range(len(used_cells)):
#		if used_cells[i].x < min_x or min_x==-1:
#			min_x = used_cells[i].x 
#		if used_cells[i].y < min_y or min_y==-1:
#			min_y = used_cells[i].y 
#
#	var position = Vector2i(min_x,min_y)
#	var pattern = get_pattern(Layer.OBJECT,used_cells)
#
#	file.store_64(rows)
#	file.store_64(columns)
#	file.store_var(position, true)
#	file.store_var(pattern, true)
#
#
###[method save_to_file]:
###loads a Garden plan from a file
###The file must already be open for reading.
#func load_from_file(file:FileAccess)->void:
#
#	var rows = file.get_64()
#	var columns = file.get_64()
#	var position = file.get_var(true)
#	var pattern = file.get_var(true)
#
#	self.create_garden(rows,columns)
#	self.set_pattern(Layer.OBJECT,position,pattern)
