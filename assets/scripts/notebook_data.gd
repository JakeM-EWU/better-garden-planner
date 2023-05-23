extends Node

@onready var _notebook_data = {}

func update_notes(new_notebook_state:Dictionary):
	self._notebook_data = new_notebook_state
	print("backend notes:",self._notebook_data)
	GardenSignalBus.notebook_updated.emit(self._notebook_data.duplicate())
	
func save_to_file(file:FileAccess):
	file.store_var(self._notebook_data,true)

func load_from_file(file:FileAccess):
	self._notebook_data = file.get_var(true)
	GardenSignalBus.notebook_updated.emit(self._notebook_data.duplicate())
