extends Panel

var notes = {}  # A dictionary to store the notes. Keys are the note titles.

signal notebook_update_requested(notebook_state:Dictionary)

func _ready():
	pass  # This function is called when the node and its children have entered the scene tree.

func on_notebook_updated(notebook_state):
	self.notes = notebook_state

# When Add Note button is pressed
func on_add_note_button_pressed():
	var new_note_title = $NoteTitleEdit.text
	var new_note_content = $NoteContentsEdit.text
	if new_note_title and new_note_content:
		if new_note_title not in notes:
			notes[new_note_title] = new_note_content
			var index = $NoteList.add_item(new_note_title)
			$NoteList.select(index)
		else:
			printerr("Title is not unique. Note not added.")
	else:
		printerr("Title or content is empty. Note not added.")


# When Delete Note button is pressed
func on_delete_note_button_pressed():
	if $NoteList.is_anything_selected():
		var selected_note_index = $NoteList.get_selected_items()[0]
		var selected_note_title = $NoteList.get_item_text(selected_note_index)
		notes.erase(selected_note_title)
		$NoteList.remove_item($NoteList.get_selected_id())

# When Save button is pressed
func on_save_button_pressed():
	if $NoteList.is_anything_selected():
		var selected_note_index = $NoteList.get_selected_items()[0]
		var selected_note_title = $NoteList.get_item_text(selected_note_index)
		var new_title = $NoteTitleEdit.text
		if selected_note_title in notes:
			
			if new_title != selected_note_title:
				if new_title not in notes:
					notes[new_title] = $NoteContentsEdit.text
					notes.erase(selected_note_title)
					$NoteList.set_item_text(selected_note_index,new_title)
				else:
					printerr("Title is not unique. Note not saved.")
			else:
				notes[selected_note_title] = $NoteContentsEdit.text
		
		else:
			printerr("No such note to save.")

# When Exit button is pressed
func on_exit_button_pressed():
	close_notes()

func open_notes():
	show()

func close_notes():
	hide()
	notebook_update_requested.emit(notes.duplicate())

func _on_note_list_item_selected(index):
	var note_title = $NoteList.get_item_text(index)
	$NoteContentsEdit.text = notes[note_title]
	$NoteTitleEdit.text = note_title

