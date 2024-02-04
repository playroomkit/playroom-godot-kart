extends Control


@export_dir var race_scene

@onready var playroom : PlayroomInstance = Playroom.instance


func _ready():
	
	# register callback to listen for changes from host
	playroom.playroom_rpc_register("lobby_load_race", _rpc_start_race)
	
	print("player lobby readied")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _rpc_start_race(args):
	get_tree().change_scene_to_packed(load(race_scene))
