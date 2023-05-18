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








