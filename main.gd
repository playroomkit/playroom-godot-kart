
# entry point for the program on startup
extends Node

@export var change_scene_to : PackedScene

func _ready():
	
	# switch immediately to the menu level
	get_tree().change_scene_to_packed(change_scene_to)

