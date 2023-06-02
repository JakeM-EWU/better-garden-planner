extends Node
## this class stores the data 
@onready var _notebook_data = {}


##[method update_notebook_data] this method takes in a dictionary of notes 
##and sets the state of the notebook to a copy of the passed in dictionary. 
##It then emits a [signal GardenSignalBus.notebook_updated] signal
##to alert the UI of the change.
func update_notebook_data(new_notebook_state:Dictionary):
	self._notebook_data = new_notebook_state
	print(_notebook_data)
	#print("backend notes:",self._notebook_data)
	GardenSignalBus.notebook_updated.emit(self._notebook_data.duplicate())

##[method save_to_file] this method takes in a file 
##and saves the notebook's data to that file.
func save_to_file(file:FileAccess):
	file.store_var(self._notebook_data,true)

##[method load_from_file] this method takes in a file, 
##loads a notebook dictionary from the file, and updates
##the notebook_data
func load_from_file(file:FileAccess):
	var new_notebook_state = file.get_var(true)
	update_notebook_data(new_notebook_state)
