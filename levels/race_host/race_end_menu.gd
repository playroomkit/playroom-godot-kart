extends CanvasLayer

## ?? circular reference in packedscenes :wail:
#@export var menu_scene: PackedScene

func _on_raceagain_pressed():
	get_tree().reload_current_scene()


func _on_backtomenu_pressed():
	#print("null menu scene? ", menu_scene)
	get_tree().change_scene_to_packed(preload("res://levels/race_host/main_menu.tscn"))
