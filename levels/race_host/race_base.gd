
## playroom kart stream host - holds multiplayer logic
# TODO make generic?


class_name StreamBase
extends Node3D



# ----- FIELDS -----

## set true if remote client (not host)
@export var remote = false

@export var track_base : TrackBase
@export var race_ui : RaceUI
@export var race_tracker : RaceTracker

@export_category("Preloads")
@export var racer_puppet_template : PackedScene

@onready var playroom : PlayroomInstance = Playroom.instance

## populated by joined players on scene load (late joiners can spectate TODO) 
var racers : Array[RacerPuppet]
var my_racer : RacerPuppet



# ----- CALLBACKS -----



func _ready():
	
	var my_player = playroom.playroom_my_player()
	
	# populate and set up racers
	for player in playroom.players.values():
		var racer = _create_racer(player)
		racers.push_back(racer)
		
		# keep track of my player's racer
		if player.player_state.id == my_player.id: 
			my_racer = racer
			track_base.my_racer = racer
	
	# set ui racers
	for racer in racers:
		race_ui.add_player(racer)
	
	# waits one frame for everything to load
	# this is hacky
	await get_tree().process_frame
	
	# ready 
	race_tracker.setup_race(racers)
	
	# TODO wait for all players to ready (load ping)
	
	_start_race()



# ----- PRIVATE -----



func _start_race():
	# go!
	race_tracker.start_race()


func _create_racer(player : PlayroomPlayer) -> RacerPuppet:
	var racer : RacerPuppet = racer_puppet_template.instantiate()
	add_child(racer) # make sure it's being processed in the scene tree
	racer.setup(player, track_base)
	return racer
