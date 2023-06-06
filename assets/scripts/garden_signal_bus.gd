extends Node

signal object_placed(row: int, col: int, object_key: String)
signal object_removed(row:int, col: int)
signal size_set(rows:int, columns:int)
signal cleared()
signal get_placed_objects(placed_objects: Array)
signal notebook_updated(notebook_state:Dictionary)
signal hide_title_screen
