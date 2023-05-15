extends Panel

var notes = {}  # A dictionary to store the notes. Keys are the note titles.

func _ready():
	pass  # This function is called when the node and its children have entered the scene tree.

# When Add Note button is pressed
func on_add_note_button_pressed():
	var new_note_title = $NoteTitleEdit.text
	var new_note_content = $NoteContentsEdit.text
	if new_note_title and new_note_content:
		notes[new_note_title] = new_note_content
		$NoteList.add_item(new_note_title)
	else:
		print("Title or content is empty. Note not added.")

# When Delete Note button is pressed
func on_delete_note_button_pressed():
	var selected_note_title = $NoteList.get_selected_items()[0]
	notes.erase(selected_note_title)
	$NoteList.remove_item($NoteList.get_selected_id())

# When Save button is pressed
func on_save_button_pressed():
	var selected_note_title = $NoteList.get_selected_items()[0]
	if selected_note_title in notes:
		notes[selected_note_title] = $NoteContentsEdit.text
	else:
		print("No such note to save.")

# When Exit button is pressed
func on_exit_button_pressed():
	get_tree().quit()  # Close the application.
