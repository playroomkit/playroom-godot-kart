
## Launches playroom - 
## when coin is inserted, launches either mobile scene (controller) or 
## race scene (host)

class_name StartingMenu
extends Control

# ----- FIELDS -----

@export var controller_scene : PackedScene
@export var race_scene : PackedScene

var stream_mode = false
var debug = false
var remote = false

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
	stream_mode = true
	_start_playroom()


func _on_button_remote_pressed():
	remote = true
	_start_playroom()


func _on_button_debug_pressed():
	debug = true
	_start_playroom()


func _on_playroom_coin_inserted(args):
	
	if debug: 
		_switch_scene_debug()
	elif remote: 
		_switch_scene_remote()
	else: 
		_switch_scene()



# ----- PRIVATE ------



func _start_playroom():
	Playroom.instance.stream_mode = stream_mode
	Playroom.instance.start_playroom()


# for stream mode - sets up game as main screen + controllers
func _switch_scene():
	if playroom.playroom_is_stream_screen():
		get_tree().change_scene_to_packed(race_scene)
	else:
		get_tree().change_scene_to_packed(controller_scene)


# gives controls to the main scene
func _switch_scene_debug():
	if playroom.playroom_is_host(): 
		get_tree().change_scene_to_packed(race_scene)
	else:
		get_tree().change_scene_to_packed(controller_scene)



func _switch_scene_remote():
	pass
