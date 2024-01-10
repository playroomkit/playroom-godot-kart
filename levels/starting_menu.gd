extends Control



@export var next_scene : PackedScene



func _ready():
	# connect to the playroom instance signal to listen for game start -
	# done in code since the playroom global isn't placed in the tree until runtime
	Playroom.instance.coin_inserted.connect(_on_playroom_coin_inserted)



func _start_playroom():
	Playroom.instance.start_playroom()


func _switch_scene():
	get_tree().change_scene_to_packed(next_scene)



# this callback was connected to a button through the editor
func _on_button_pressed():
	_start_playroom()


func _on_playroom_coin_inserted(args):
	_switch_scene()
