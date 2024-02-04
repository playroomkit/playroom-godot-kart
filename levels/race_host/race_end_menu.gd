
# this menu is only invoked on host

class_name RaceEndMenu
extends CanvasLayer

@export_dir var host_lobby

@onready var playroom : PlayroomInstance = Playroom.instance


func _on_raceagain_pressed():
	
	playroom.playroom_rpc_call("reload_race", {})
	get_tree().reload_current_scene()


func _on_backtomenu_pressed():
	
	playroom.playroom_rpc_call("back_to_lobby")
	playroom.playroom_reset_players_states()

	get_tree().change_scene_to_packed(load(host_lobby))





