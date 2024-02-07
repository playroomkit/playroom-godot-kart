
## race logic (laps, winner etc)

class_name RaceTracker
extends Node


signal countdown(current_count)

@export var countdown_seconds = 3
@export var max_laps = 2
@export var num_gates = 1
@export var ui : RaceUI
@export var end_menu : CanvasLayer

@onready var count : Timer = $Count
@onready var playroom : PlayroomInstance = Playroom.instance

var current_countdown = countdown_seconds
var winner = null
var is_host = false

## lap dictionary, racer -> lap
var lap_dictionary = {}

## checkpoint dictionary, racer -> checkpoint
var checkpoint_dictionary = {}



func _ready():
	is_host = playroom.playroom_is_host()
	
	# register client rpcs
	if !is_host:
		playroom.playroom_rpc_register("race_won", _rpc_race_won)



## array of racers to participate in race
func setup_race(racers: Array[RacerPuppet]):
	
	# initialize dicts
	for racer in racers:
		lap_dictionary[racer] = 0
		checkpoint_dictionary[racer] = 0
		
		# listen for racer passing new lap
		racer.lap_passed.connect(_on_player_new_lap)


## start things moving once waiting is done
func start_race():
	
	# get ready
	ui.racers_ready()
	
	# fashionable delay
	await get_tree().create_timer(5).timeout
	
	# start count
	_start_countdown()



# ----- PRIVATE -----



# unlock racers
func _go():
	for racer in lap_dictionary.keys():
		racer.unlock_car()


func _start_countdown():
	countdown.emit(current_countdown)
	count.start()


func _on_count_timeout():
	current_countdown -= 1
	countdown.emit(current_countdown)
	if current_countdown <= 0: 
		_go()
	else:
		count.start()


func _on_player_new_lap(racer, gate):
	
	var last_gate = checkpoint_dictionary[racer]
	
	# finish line passed correctly:
	if gate == 0 and last_gate == 1:
		
		# increment lap and display
		lap_dictionary[racer] += 1
		var laps = lap_dictionary[racer]
		ui.update_racer_lap(racer, laps)
		
		# first to reach max laps wins
		if winner == null and laps >= max_laps:
			_check_winner(racer)
	
	# correct gate pass / first gate after finishing lap
	elif last_gate == gate + 1 or (last_gate == 0 and gate == num_gates):
		checkpoint_dictionary[racer] = gate
	
	# incorrectly passed gate
	else:
		print(racer.player_state.getProfile().name, "PASSED GATE INCORRECTLY")
	
	


# if host determined winner, tell players to set winner by RPC
# the sets winner for self
func _check_winner(racer):
	if !is_host: return
	
	playroom.playroom_rpc_call("race_won", {"winner_id" : racer.player_state.id})
	_set_winner(racer.player_state)


# receives RPC here if client 
func _rpc_race_won(args):
	var id = args[0]["winner_id"]
	var winner_state = playroom.players_id[id]
	_set_winner(winner_state)


# called on all players (sets ui and winner field)
func _set_winner(state : JavaScriptObject):
	
	winner = state
	ui.set_winner(state)
	
	# show end menu to host
	if is_host:
		
		# fancy delay
		await get_tree().create_timer(2).timeout
		
		end_menu.show()
		end_menu.visible = true


