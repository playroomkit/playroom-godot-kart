
## race logic (laps, winner etc)

class_name RaceTracker
extends Node


@export var max_laps = 2
@export var ui : RaceUI

var winner = null

## lap dictionary, racer -> lap
var lap_dictionary = {}

## checkpoint dictionary, racer -> checkpoint
var checkpoint_dictionary = {}


func start_race(racers: Array[RacerPuppet]):
	
	# initialize dicts
	for racer in racers:
		lap_dictionary[racer] = 0
		
		# listen for racer passing new lap
		racer.lap_passed.connect(_on_player_new_lap)


func _on_player_new_lap(racer):
	print("Race tracker recieved new lap!")
	lap_dictionary[racer] += 1
	var laps = lap_dictionary[racer]
	ui.update_racer_lap(racer, laps)
	
	if winner == null and laps >= max_laps:
		ui.set_winner(racer)
