class_name ObjectLibrary
extends Control

@onready var object_list: ItemList = get_node("Object List")

signal object_selected(object_name)

func _ready():
	populate_library("")


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


func _on_object_list_item_selected(index):
	var object_name = object_list.get_item_text(index)
	object_selected.emit(object_name)
