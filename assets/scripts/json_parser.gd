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


## Returns planting date range start as string
func get_planting_date_range_start(object: String) -> String:
	var item_data: Dictionary = garden_data[object]
	if (item_data.get("PlantingDateRangeStart")):
		return item_data["PlantingDateRangeStart"] as String
	else:
		return ""

## Returns planting date range end as string
func get_planting_date_range_end(object: String) -> String:
	var item_data: Dictionary = garden_data[object]
	if (item_data.get("PlantingDateRangeEnd")):
		return item_data["PlantingDateRangeEnd"] as String
	else:
		return ""

## Returns sowing location (indoors/outdoors) as string
func get_sowing_location(object: String) -> String:
	var item_data: Dictionary = garden_data[object]
	if (item_data.get("SowingLocation")):
		return item_data["SowingLocation"] as String
	else:
		return ""


func get_sprite_source_id(object: String) -> int:
	var item_data: Dictionary = garden_data[object]
	if (item_data.has("Sprite Source ID")):
		return item_data["Sprite Source ID"] as int
	else:
		return -1


## Checks if an item has a field, and if so, whether or it contains content.
func contains_dictionary(item_data: Dictionary, entry: String) -> bool:
	return item_data.has(entry) and item_data[entry] is Dictionary
	
