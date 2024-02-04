
## handles input map input and logs inputs to my player's player_state

class_name MyRacerInputHandler
extends Node


@onready var playroom : PlayroomInstance = Playroom.instance
@onready var my_state : JavaScriptObject = playroom.playroom_my_player()


func _input(event):
	
	if my_state == null: my_state = playroom.playroom_my_player()
	
	if event.is_action_pressed("ui_up"):  my_state.setState("up_input", true)
	if event.is_action_released("ui_up"): my_state.setState("up_input", false)
	
	if event.is_action_pressed("ui_down"):  my_state.setState("down_input", true)
	if event.is_action_released("ui_down"): my_state.setState("down_input", false)
	
	if event.is_action_pressed("ui_left"):  my_state.setState("left_input", true)
	if event.is_action_released("ui_left"): my_state.setState("left_input", false)
	
	if event.is_action_pressed("ui_right"):  my_state.setState("right_input", true)
	if event.is_action_released("ui_right"): my_state.setState("right_input", false)
