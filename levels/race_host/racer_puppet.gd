
## controls an individual racer for the host, processing async client input.
## also stores data.
## WARNING may occasionally await client!

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


## called by host as a pseudo-constructor
func setup(player_state, track_base):
	
	self.player_state = player_state
	self.track_base = track_base
	
	# then wait for player to finish setup
	print("waiting for racer to ready...")
	await playroom.playroom_await_player_state(player_state, "ready", _on_player_finished_setup)
	#await playroom.playroom_await_test(player_state, "ready")
	print("racer awaited")
	#_on_player_finished_setup()


func _on_player_finished_setup():
	
	print("racer puppet received client ready!")
	
	# finish setting up
	joystick = player_state.getState("joystick")
	
	# spawn car
	car = car_template.instantiate()
	track_base.add_car(car)
	
	print("car spawned: ", car)

