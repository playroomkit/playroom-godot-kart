# playroom chatroom


extends Node2D


@export var text_display : RichTextLabel
@export var line_edit : LineEdit

var playroom : PlayroomInstance
var my_player ## player state


func _ready():
	playroom = Playroom.instance
	print("PLAYROOM: ", playroom)
	my_player = playroom.playroom_my_player()


func _process(delta):
	
	# if host, check all player text state, append to push state, clear text state 
	if playroom.playroom_is_host():
		
		# get current display text
		var display_text = my_player.getState("chat_display")
		if display_text == null: display_text = ""
		
		# append any waiting messages
		for p in playroom.player_states:
			var text = p.getState("chat_text")
			if text != null:
				print("PLAYER CHAT NOT NULL: ", p.id, ", ", text)
				var p_name = p.getProfile().name
				display_text = display_text + "\n" + p_name + ": " + text
				p.setState("chat_text", null)
		
		# push appended display text back to players
		for p in playroom.player_states:
			p.setState("chat_display", display_text)
	
	# if all, check display state, display
	text_display.text = my_player.getState("chat_display")


func _on_line_edit_text_submitted(new_text):
	
	# add text to player's chat text state
	var state = playroom.playroom_my_player()
	state.setState("chat_text", new_text)
	
	line_edit.clear()
