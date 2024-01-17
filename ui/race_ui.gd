
class_name RaceUI
extends CanvasLayer


@onready var race_tracker = $"../RaceTracker"
@onready var label = $Control/MarginContainer/VBoxContainer/Label
@onready var countdown = $Control/MarginContainer/VBoxContainer/Countdown

@export_category("Containers")
@export var player_box_container : Container

@export_category("Preloads")
@export var player_box_preload : PackedScene


var player_boxes = {}


func _on_race_tracker_countdown(current_count):
	countdown.visible = true
	countdown.text = str(current_count)
	
	if current_count <= 0:
		
		countdown.text = "GO!"
		
		# shows go for a moment
		await get_tree().create_timer(2).timeout
		countdown.visible = false


func add_player(racer : RacerPuppet):
	var box = player_box_preload.instantiate()
	player_box_container.add_child(box)
	box.setup(racer)
	player_boxes[racer] = box


func update_racer_lap(racer, lap):
	print("UI updating lap...")
	print(player_boxes[racer])
	player_boxes[racer].update_lap(lap)


func set_winner(racer):
	var state = racer.player_state
	label.text = state.getProfile().name + " WINS!"



