extends Control


@export var race_scene : PackedScene

@onready var playroom : PlayroomInstance = Playroom.instance


func _ready():
	
	# register callback to listen for changes from host
	playroom.playroom_rpc_register("race_state_changed", _rpc_race_state_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# TODO global level list, load_race as separate RPC
func _rpc_race_state_changed(args):
	print("PLAYER: ", playroom.playroom_my_player().id ," RPC RECEIVED")
	var data = args[0]
	print(data.state_change)
	if data.state_change == "load_race":
		get_tree().change_scene_to_packed(race_scene)
