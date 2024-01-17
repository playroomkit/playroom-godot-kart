
class_name RaceUI
extends CanvasLayer


@onready var race_tracker = $"../RaceTracker"

@export_category("Containers")
@export var player_box_container : Container

@export_category("Preloads")
@export var player_box_preload : PackedScene


var player_boxes = {}


func add_player(racer : RacerPuppet):
	var box = player_box_preload.instantiate()
	player_box_container.add_child(box)
	box.setup(racer)
	player_boxes[racer] = box


func update_racer_lap(racer, lap):
	print("UI updating lap...")
	print(player_boxes[racer])
	player_boxes[racer].update_lap(lap)

