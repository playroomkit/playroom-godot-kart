
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
	await get_tree().process_frame
	print("finished waiting for frame")
	
	# "waiting for other.."
	race_ui.racers_waiting()
	
	# setup racers
	race_tracker.setup_race(racers)
	
	# at this point, this player is considered loaded and ready to start
	playroom.playroom_my_player().setState("race_ready", true)
	
	# if host, wait until all other players are ready
	if playroom.playroom_is_host():
		print("host is awaiting all ready")
		var timeout = await _await_all_ready(1)
		print("host: all players are ready, starting race")
		
		# once all players are ready, start race for all
		playroom.playroom_rpc_call("start_race", {})
		
		# start race for self
		_start_race()
	
	# if client, setup RPC to wait until the host is ready to start
	else:
		print("client, waiting for host to start")
		playroom.playroom_rpc_register("start_race", _rpc_start_race)



# ----- PRIVATE -----



# checks all players for state.race_ready every ping interval 
func _await_all_ready(ping_interval, timeout = 20):
	
	var pings = 0
	
	while pings <= timeout:
		
		# cycle racers
		var count = 0
		for r in racers:
			if (r.player_state.getState("race_ready")) : count += 1
		
		# return if all true
		if count >= racers.size(): return true
		
		pings += 1
		await get_tree().create_timer(ping_interval).timeout
	
	# timed out
	return false


# if this is client, called by host to start race 
func _rpc_start_race(args):
	print("client received rpc! starting race")
	_start_race()


func _start_race():
	# go!
	race_tracker.start_race()


func _create_racer(player : PlayroomPlayer) -> RacerPuppet:
	var racer : RacerPuppet = racer_puppet_template.instantiate()
	add_child(racer) # make sure it's being processed in the scene tree
	racer.setup(player, track_base)
	return racer
