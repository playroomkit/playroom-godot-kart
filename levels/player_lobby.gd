
class_name PlayerLobby
extends Control


@export_dir var controller_scene_path  = "res://levels/controller_scene.tscn"
@export_dir var remote_scene_path = "res://levels/remote_player/remote_player_base.tscn"


func _on_lancontrollerjoin_pressed():
	get_tree().change_scene_to_packed(load(controller_scene_path))


func _on_remoteplayerjoin_pressed():
	get_tree().change_scene_to_packed(load(remote_scene_path))
