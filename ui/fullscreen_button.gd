## control button for toggling fullscreen

class_name FullscreenButton
extends Button


@export var fullscreen_type = DisplayServer.WINDOW_MODE_FULLSCREEN
@export var other_type = DisplayServer.WINDOW_MODE_MAXIMIZED


func _process(delta):
	# check if game has been minimized any other way
	#if DisplayServer.window_get_mode() != fullscreen_type:
		#button_pressed = false
	pass


func _on_toggled(toggled_on):
	
	print("checkbutton toggled!")
	
	if toggled_on : 
		print("toggled on")
		DisplayServer.window_set_mode(fullscreen_type)
	else:
		print("toggled off")
		DisplayServer.window_set_mode(other_type)
