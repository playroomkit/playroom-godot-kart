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
	
	# create player controls
	_create_my_joystick()
	
	# let host know that player is finished setting up
	my_player.setState("ready", true)



# ----- PRIVATE ----- 



# create playroom controls for my player -
# set reference in player state["joystick"]
func _create_my_joystick():
	
	# set joystick options
	var joy_options = JavaScriptBridge.create_object("Object")
	joy_options.type = "dpad"
	
	# create gas button
	var gas_button = JavaScriptBridge.create_object("Object")
	gas_button.id = "gas"
	gas_button.label = "A"
	
	# create brake button
	var brake_button = JavaScriptBridge.create_object("Object")
	brake_button.id = "brake"
	brake_button.label = "B"
	
	# add buttons to playroom joystick
	var joy_buttons = JavaScriptBridge.create_object("Array")
	joy_buttons.push(gas_button)
	joy_buttons.push(brake_button)
	joy_options.buttons = joy_buttons
	
	# create joystick
	JavaScriptBridge.eval("Joystick = Playroom.Joystick")
	var joystick = JavaScriptBridge.create_object("Joystick", my_player, joy_options)
	my_joystick = joystick
	
	# reference my joystick in my player state
	my_player.setState("joystick", joystick)
	
	print("joystick initialized: ", my_player.id)
	print("stored: ", my_player.getState("joystick"))
