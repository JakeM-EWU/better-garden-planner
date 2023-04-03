extends Node

var garden_data = {}

# singleton that runs at launch, creates a nested dictionary of garden objects
# print statements are just to verify that it's working and to show format of each object for now

func _ready():
	var file = FileAccess.open("res://assets/data/plant_data.json", FileAccess.READ)
	var json_object = JSON.new()
	var parse_err = json_object.parse(file.get_as_text())
	garden_data = json_object.get_data()
	
	for obj in garden_data:
		print(obj)
		for ind in garden_data[obj]:
			print(ind, ": ", garden_data[obj][ind])

