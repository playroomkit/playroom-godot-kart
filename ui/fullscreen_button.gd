## control button for toggling fullscreen

class_name FullscreenButton
extends Button


@export var fullscreen_type = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
@export var other_type = DisplayServer.WINDOW_MODE_MINIMIZED


func _process(delta):
	# check if game has been minimized any other way
	if DisplayServer.window_get_mode() != fullscreen_type:
		button_pressed = false


func _on_toggled(toggled_on):
	if toggled_on : 
		DisplayServer.window_set_mode(fullscreen_type)
	else:
		DisplayServer.window_set_mode(other_type)
