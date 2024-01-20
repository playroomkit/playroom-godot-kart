extends Control

@onready var player_name = $VBoxContainer/PlayerName

func setup(racer : RacerPuppet):
	
	var state = racer.player_state
	var name_text = state.getProfile().name
	var color = state.getProfile().color.hexString # color as hexstring
	
	# bbcode parses hexstring
	player_name.text = "[center][color=" + color + "]" + name_text + "[center]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
