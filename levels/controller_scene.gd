## playroom kart phone controller

class_name ControllerScene
extends Node2D



# ----- FIELDS -----



var playroom : PlayroomInstance
var my_player = null
var my_joystick = null



# ----- CALLBACKS -----



func _ready():
	
	# set fullscreen on startup
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	# get playroom instance and player
	playroom = Playroom.instance
	my_player = playroom.playroom_my_player()
	
	# let host know that player is finished setting up
	my_player.setState("ready", true)



# ----- PRIVATE ----- 

