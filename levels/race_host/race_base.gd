
## playroom kart stream host - holds multiplayer logic


class_name StreamBase
extends Node3D



# ----- FIELDS -----



@export var track_base : TrackBase

@export_category("Preloads")
@export var racer_puppet_template : PackedScene

var playroom : PlayroomInstance

## populated by joined players on scene load (late joiners can spectate TODO) 
var racers : Array[RacerPuppet]




# ----- CALLBACKS -----



func _ready():
	
	playroom = Playroom.instance
	
	# populate and set up racers
	for state in playroom.player_states:
		racers.push_back(_create_racer(state))



# ----- PRIVATE -----



func _create_racer(player_state) -> RacerPuppet:
	var racer : RacerPuppet = racer_puppet_template.instantiate()
	add_child(racer) # make sure it's being processed in the scene tree
	racer.setup(player_state, track_base)
	return racer
