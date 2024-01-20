
## RACE GUI -
## creates player info boxes on startup.
## sets the big banner label to relevant text.


class_name RaceUI
extends CanvasLayer


@onready var race_tracker = $"../RaceTracker"
@onready var label = $Control/MarginContainer/VBoxContainer/label

@export_category("Containers")
@export var player_box_container : Container

@export_category("Preloads")
@export var player_box_preload : PackedScene


var player_boxes = {}



# ----- CALLBACKS -----



func _on_race_tracker_countdown(current_count):
	label.visible = true
	label.text = str(current_count)
	
	if current_count <= 0:
		
		label.text = "GO!"
		
		# shows go for a moment
		await get_tree().create_timer(2).timeout
		label.visible = false



# ----- PUBLIC -----



func add_player(racer : RacerPuppet):
	var box = player_box_preload.instantiate()
	player_box_container.add_child(box)
	box.setup(racer)
	player_boxes[racer] = box


func racers_ready():
	label.text = "RACERS READY"


func update_racer_lap(racer, lap):
	
	print("UI updating lap...")
	print(player_boxes[racer])
	player_boxes[racer].update_lap(lap)


func set_winner(racer):
	var state = racer.player_state
	label.visible = true
	label.text = state.getProfile().name + " WINS!"



