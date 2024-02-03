extends Control


@export_dir var race_scene

@onready var playroom : PlayroomInstance = Playroom.instance


func _ready():
	
	# register callback to listen for changes from host
	playroom.playroom_rpc_register("race_state_changed", _rpc_race_state_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# TODO global level list, load_race as separate RPC
func _rpc_race_state_changed(data, caller):
	if data == "load":
		get_tree().change_scene_to_packed(load(race_scene))
