extends Window

var inventory = []
var mynode = Label.new()

@onready var object_list: ItemList = get_node("InventoryList")

# Called when the node enters the scene tree for the first time.
func _ready():
	GardenSignalBus.get_placed_objects.connect(_on_get_placed_objects)

	pass # Replace with function body.
	
	
func _on_get_placed_objects(object):
	var inventory_tally = {}
	var container = VBoxContainer.new()
	add_child(container)
	for row in object:
		for item in row:
			if item != "":
				if inventory_tally.has(item):
					inventory_tally[item] += 1
				else:
					inventory_tally[item] = 1
	populate_inventory(inventory_tally)

func populate_inventory(inventory_tally): 
	object_list.clear()
	if(len(inventory_tally)== 0):
		object_list.add_item("Place objects in your garden")
		object_list.add_item("to view inventory")
	
	for value in inventory_tally:
		var item = value + ": " + str(inventory_tally[value])
		object_list.add_item(item)
	object_list.sort_items_by_text()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_requested():
	self.hide() # Replace with function body.


