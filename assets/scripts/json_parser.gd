extends Node

var garden_data: Dictionary = {}

# singleton that runs at launch, creates a nested dictionary of garden objects
# print statements are just to verify that it's working and to show format of each object for now

func _ready():
	var file = FileAccess.open("res://assets/data/plant_data.json", FileAccess.READ)
	var json_object = JSON.new()
	var parse_err = json_object.parse(file.get_as_text())
	garden_data = json_object.get_data()
	
#	for obj in garden_data:
#		print(obj)
#		for ind in garden_data[obj]:
#			print(ind, ": ", garden_data[obj][ind])


## Returns a dictionary containing the Indoor Planting dates for Frost and Moon for the given key. Returns an empty dictionary if N/A.
func get_start_seeds_indoors(object: String) -> Dictionary:
	var item_data: Dictionary = garden_data[object]
	if (contains_dictionary(item_data, "Start Seeds Indoors")):
		return item_data["Start Seeds Indoors"] as Dictionary
	else:
		return {}

## Returns a dictionary containing the Plant Seedlings or Transplants dates for Frost and Moon for the given key. Returns an empty dictionary if N/A.
func get_plant_seedlings_or_transplants_data(object: String) -> Dictionary:
	var item_data: Dictionary = garden_data[object]
	if (contains_dictionary(item_data, "Plant Seedlings or Transplants")):
		return item_data["Plant Seedlings or Transplants"] as Dictionary
	else:
		return {}

## Returns a dictionary containing the Outdoor Planting dates for Frost and Moon for the given key. Returns an empty dictionary if N/A.
func get_start_seeds_outdoors_data(object: String) -> Dictionary:
	var item_data: Dictionary = garden_data[object]
	if (contains_dictionary(item_data, "Start Seeds Outdoors")):
		return item_data["Start Seeds Outdoors"] as Dictionary
	else:
		return {}


func get_sprite_source_id(object: String) -> int:
	var item_data: Dictionary = garden_data[object]
	if (item_data.has("Sprite Source ID")):
		return item_data["Sprite Source ID"] as int
	else:
		return -1


## Checks if an item has a field, and if so, whether or it contains content.
func contains_dictionary(item_data: Dictionary, entry: String) -> bool:
	return item_data.has(entry) and item_data[entry] is Dictionary
	
