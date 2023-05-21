extends Node

signal object_placed(row: int, col: int, object_key: String)
signal object_removed(row:int, col: int)
signal size_set(rows:int, columns:int)
signal cleared()
