
## displays player information with player boxes (same as race ui).
## creates QR code using Iceflower's QR code plugin

extends Control


@export var race_scene : PackedScene
@export var player_boxes : Container
@export var player_box_scene : PackedScene
@export var qr_code_rect : QRCodeRect

var playroom : PlayroomInstance

func _ready():
	playroom = Playroom.instance
	
	# register signal to monitor for new players joining
	playroom.player_joined.connect(_on_playroom_player_joined)
	
	# register all current players
	for state in playroom.players.keys():
		_add_player_box(state)
	
	# set up qr code
	qr_code_rect.data = playroom.current_url


func _on_race_pressed():
	print("button pressed")
	get_tree().change_scene_to_packed(race_scene)


func _on_quit_pressed():
	SceneTree.quit


func _on_playroom_player_joined(args):
	# host is stream lobby - don't display name
	print("SDJFAIOASDFIJO")
	print("comparing ids ", args[0].id, playroom.playroom_my_player().id)
	if args[0].id == playroom.playroom_my_player().id: return
	_add_player_box(args[0])


func _add_player_box(state):
	var box = player_box_scene.instantiate()
	player_boxes.add_child(box)
	box.setup(state)
	box.hide_laps()
