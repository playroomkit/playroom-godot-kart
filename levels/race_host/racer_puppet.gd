
## controls an individual racer for the host, processing async client input.
## also stores data.
## WARNING may occasionally await client!

# TODO make generic?

class_name RacerPuppet
extends Node



# ----- FIELDS -----



@export_category("Preloads")
@export var car_template : PackedScene

var playroom : PlayroomInstance
var track_base : TrackBase 
var player_state = null
var joystick = null
var car : CarBase



# ----- CALLBACKS -----



func _ready():
	playroom = Playroom.instance


func _process(delta):
	
	_process_joy_inputs()
	
	
	
	pass


## called by host as a pseudo-constructor
func setup(player_state, track_base):
	
	self.player_state = player_state
	self.track_base = track_base
	
	# then wait for player to finish setup
	#print("waiting for racer to ready...")
	#await playroom.playroom_await_player_state(player_state, "ready")
	#print("racer puppet received client ready!")
	#
	## finish setting up
	#joystick = player_state.getState("joystick")
	
	# spawn car
	car = car_template.instantiate()
	track_base.add_car(car)



# ----- PRIVATE -----



# process joystick inputs!
func _process_joy_inputs():
	if joystick == null: 
		joystick = player_state.getState("joystick")
		print("retrieving joystick: ", joystick, " player ", player_state.id)
	if joystick == null:
		return
	
	var dpad = joystick.dpad
	
	if dpad.y == "up":
		print("JOY IS UP: ", player_state.id)
		car.press_gas()
	elif dpad.y == "down":
		car.press_brake()
