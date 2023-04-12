extends Control

@onready var item_icon: TextureRect = get_node("ItemIcon")
@onready var item_name: Label = get_node("ItemName")


func set_data(name: String):
	item_name.text = name
