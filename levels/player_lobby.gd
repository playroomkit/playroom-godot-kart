
class_name PlayerLobby
extends Control


@export var controller_scene_path  = "res://levels/controller_scene.tscn"
@export var remote_scene_path : String


func _on_lancontrollerjoin_pressed():
	get_tree().change_scene_to_packed(load(controller_scene_path))


func _on_remoteplayerjoin_pressed():
	pass # Replace with function body.
