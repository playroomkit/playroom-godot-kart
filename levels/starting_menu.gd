
## Launches playroom - 
## when coin is inserted, launches host into the stream lobby,
## and launches subsequent joiners into the player lobby 
## to choose between being a LAN controller or remote player

class_name StartingMenu
extends Control

# ----- FIELDS -----

@export var stream_lobby : PackedScene
@export var player_lobby : PackedScene

var playroom : PlayroomInstance



# ----- CALLBACKS -----



func _ready():
	
	# get global playroom instance
	playroom = Playroom.instance
	
	# connect to the playroom instance signal to listen for game start -
	# done in code since the playroom global isn't placed in the tree until runtime
	playroom.coin_inserted.connect(_on_playroom_coin_inserted)


# this callback was connected to a button through the editor
func _on_button_pressed():
	_start_playroom()


func _on_playroom_coin_inserted(args):
	_switch_scene()



# ----- PRIVATE ------



func _start_playroom():
	playroom.skip_lobby = true
	playroom.start_playroom()


func _switch_scene():
	if playroom.playroom_is_host():
		get_tree().change_scene_to_packed(stream_lobby)
	else:
		get_tree().change_scene_to_packed(player_lobby)
