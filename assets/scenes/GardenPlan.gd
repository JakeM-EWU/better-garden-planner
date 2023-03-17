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


func generate_garden():
	set_garden_size()
	center_garden()


func set_garden_size():
	for r in rows:
		for c in columns:
			set_cell(0, Vector2i(r, c), 0, Vector2i(0,0))


func center_garden():
	var x_pos = (garden_width_in_pixels / 2) * -1
	var y_pos = (garden_height_in_pixels / 2) * -1
	
	self.position.x = x_pos
	self.position.y = y_pos
	
