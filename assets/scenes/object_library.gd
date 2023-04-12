extends GridContainer

@onready var library_item: PackedScene = preload("res://assets/scenes/library_item.tscn")

func _ready():
	var keys = JsonParser.garden_data.keys()
	print(keys)
	for s in keys:
		var item: LibraryItem = library_item.instantiate()
		item.set_data(s)
		add_child(item)
