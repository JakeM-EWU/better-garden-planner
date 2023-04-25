extends CharacterBody2D

@export var starting: Vector2 = Vector2(0, 1)
@onready var animation_tree = $AnimationTree

func _ready():
	animation_tree.set("parameters/Idle/blend_position", starting)
