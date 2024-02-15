
## displays player information with player boxes (same as race ui).
## creates QR code using Iceflower's QR code plugin

extends Control


@export var race_scene : PackedScene
@export var player_boxes : Container
@export var player_box_scene : PackedScene
@export var qr_code_rect : QRCodeRect

@onready var loading_screen = $LoadingScreen
@onready var level_select_popup = $LevelSelectPopup
@onready var menu_container = $MarginContainer


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
	
	print("host lobby loaded")
	
	# waits one frame for everything to load
	# this is hacky
	await get_tree().process_frame
	await get_tree().process_frame
	
	loading_screen.visible = false


func _input(event):
	
	# close race popup on esc
	if event.is_action_pressed("ui_cancel"):
		level_select_popup.visible = false
		menu_container.visible = true


func _on_race_pressed():
	
	# show race popup
	level_select_popup.visible = true
	menu_container.visible = false


func _on_quit_pressed():
	SceneTree.quit


func _on_playroom_player_joined(args):
	_add_player_box(args[0])


func _add_player_box(state):
	var box = player_box_scene.instantiate()
	player_boxes.add_child(box)
	box.setup(state)
	box.hide_laps()

