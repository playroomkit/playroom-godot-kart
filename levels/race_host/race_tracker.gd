
## race logic (laps, winner etc)

class_name RaceTracker
extends Node


signal countdown(current_count)

@export var countdown_seconds = 3
@export var max_laps = 2
@export var ui : RaceUI
@export var end_menu : CanvasLayer

@onready var count : Timer = $Count

var current_countdown = countdown_seconds
var winner = null

## lap dictionary, racer -> lap
var lap_dictionary = {}

## checkpoint dictionary, racer -> checkpoint
var checkpoint_dictionary = {}


## array of racers to participate in race
func start_race(racers: Array[RacerPuppet]):
	
	# initialize dicts
	for racer in racers:
		lap_dictionary[racer] = 0
		
		# listen for racer passing new lap
		racer.lap_passed.connect(_on_player_new_lap)
	
	# get ready
	ui.racers_ready()
	
	# fashionable delay
	await get_tree().create_timer(5).timeout
	
	# start count
	_start_countdown()


## unlock racers
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


func _on_player_new_lap(racer):
	print("Race tracker recieved new lap!")
	lap_dictionary[racer] += 1
	var laps = lap_dictionary[racer]
	ui.update_racer_lap(racer, laps)
	
	if winner == null and laps >= max_laps:
		_set_winner(racer)


func _set_winner(racer):
	ui.set_winner(racer)
	
	# fancy delay
	await get_tree().create_timer(2).timeout
	end_menu.show()
	end_menu.visible = true
	


