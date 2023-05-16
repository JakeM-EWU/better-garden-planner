extends FileDialog
@export var default_path= "user://projects"
func _ready():
	var globabl_default_path = ProjectSettings.globalize_path(default_path)
	self.current_dir=globabl_default_path
	self.file_selected.connect(self.on_file_selected)
	self.canceled.connect(self.on_cancelled)
	
## [signal file_selected_or_cancelled] wraps the underlying file_dialog's
## file_selected and cancelled signals 
signal file_selected_or_cancelled(path:String)

func on_file_selected(path:String):
	file_selected_or_cancelled.emit(path)

func on_cancelled():
	file_selected_or_cancelled.emit("")
