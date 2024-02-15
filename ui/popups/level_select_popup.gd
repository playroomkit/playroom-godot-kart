extends CanvasLayer

@export var default_laps = 1
@export var race_scene : PackedScene
@export var laps_label : Label

@onready var playroom = Playroom.instance
@onready var laps = default_laps


func _ready():
	laps = default_laps
	laps_label.text = laps


func _on_minus_pressed():
	laps -= 1
	laps_label.text = str(laps)


func _on_plus_pressed():
	laps += 1
	laps_label.text = str(laps)


func _on_race_pressed():
	
	# rpc call and set laps
	playroom.playroom_rpc_call("lobby_load_race")
	playroom.playroom_set_state("laps", laps)
	
	get_tree().change_scene_to_packed(race_scene)
