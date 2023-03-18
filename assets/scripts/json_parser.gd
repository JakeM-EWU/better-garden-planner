extends Node

var garden_data

func _ready():
	var file = FileAccess.open("res://assets/data/test.json", FileAccess.READ)
	var garden_data_json = JSON.parse_string(file.get_as_text())
	garden_data = garden_data_json
	file.close()

	for object in garden_data:
		print(garden_data[object]["Start Seeds Indoors"])
		print(garden_data[object]["Plant Seedlings or Transplants"])
		print(garden_data[object]["Start Seeds Outdoors"])

