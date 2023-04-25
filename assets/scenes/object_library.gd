extends Control


@onready var object_list: ItemList = get_node("Object List")

func _ready():
	populate_library("")
	pass


func populate_library(filter: String): 
	var keys = JsonParser.garden_data.keys()
	for s in keys:
		if filter.is_empty():
			object_list.add_item(s)
		if filter.to_lower() in s.to_lower():
			object_list.add_item(s)


func _on_object_filter_text_changed(new_text):
	object_list.clear()
	populate_library(new_text)
