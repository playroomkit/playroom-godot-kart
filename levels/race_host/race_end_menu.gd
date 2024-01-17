extends CanvasLayer

@export var menu_scene: PackedScene

func _on_raceagain_pressed():
	get_tree().reload_current_scene()


func _on_backtomenu_pressed():
	pass # Replace with function body.
