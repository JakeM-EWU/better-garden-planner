extends Window

var schedule_tally = {}

@onready var grid_container: GridContainer = get_node("InventoryList/GridContainer")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	GardenSignalBus.get_placed_objects.connect(_on_get_placed_objects)

	pass # Replace with function body.
	
	
func _on_get_placed_objects(object):
	schedule_tally = {}
	var container = VBoxContainer.new()
	add_child(container)
	for row in object:
		for item in row:
			if item != "":
				if schedule_tally.has(item):
					schedule_tally[item] += 1
				else:
					schedule_tally[item] = 1
	create_schedule(schedule_tally)

func create_schedule(schedule_tally):
	var schedule = []
	for value in schedule_tally:
		var object_schedule = {
			"PlantingDateRangeStart":JsonParser.get_planting_date_range_start(value),
			"PlantingDateRangeEnd":JsonParser.get_planting_date_range_end(value),
			"SowingLocation":JsonParser.get_sowing_location(value),
			"Object": value
		}
		schedule.append(object_schedule)

	populate_schedule(schedule)


func populate_schedule(schedule): 
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		
	for item in schedule:	
		var plantLabel = Label.new()
		var plant = item["Object"]
		var start = item["PlantingDateRangeStart"]
		var end = item["PlantingDateRangeEnd"]
		var location = item["SowingLocation"]
		var txt = "Plant: {plant}\n\t\tOn or after (mm-dd): {start}\n\t\tNo later than (mm-dd): {end}\n\t\tStart seeds {location}".format({
			"plant": plant,
			"start": start,
			"end": end,
			"location": location
		})
		plantLabel.text = txt
		var objectContainer = PanelContainer.new()
		objectContainer.add_child(plantLabel)
		grid_container.add_child(objectContainer)
		
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_requested():
	self.hide() # Replace with function body.


