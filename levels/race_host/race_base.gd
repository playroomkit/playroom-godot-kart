
## playroom kart stream host - holds multiplayer logic
# TODO make generic?


class_name StreamBase
extends Node3D



# ----- FIELDS -----



@export var track_base : TrackBase
@export var race_ui : RaceUI
@export var race_tracker : RaceTracker

@export_category("Preloads")
@export var racer_puppet_template : PackedScene

var playroom : PlayroomInstance

## populated by joined players on scene load (late joiners can spectate TODO) 
var racers : Array[RacerPuppet]




# ----- CALLBACKS -----



func _ready():
	
	playroom = Playroom.instance
	
	# populate and set up racers
	for player in playroom.players.values():
		racers.push_back(_create_racer(player))
	
	# set ui racers
	for racer in racers:
		race_ui.add_player(racer)
	
	# waits one frame for everything to load
	# this is hacky
	await get_tree().process_frame
	
	# start race!
	race_tracker.start_race(racers)



# ----- PRIVATE -----



func _create_racer(player : PlayroomPlayer) -> RacerPuppet:
	var racer : RacerPuppet = racer_puppet_template.instantiate()
	add_child(racer) # make sure it's being processed in the scene tree
	racer.setup(player, track_base)
	return racer
