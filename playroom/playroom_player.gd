
## encapsulates playroom playerstate functions.
## initialized and setup by playroom instance.
## collates playroom player state, joystick, and whatever else might be needed 
## for easy access and organization

class_name PlayroomPlayer
extends Node

var player_state : JavaScriptObject
var joystick : JavaScriptObject



# ----- PUBLIC -----


func set_state(key : String, data):
	
	# primitives can be set
	# equivalent to (data is String or float or int or bool or null)
	if typeof(data) <= Variant.Type.TYPE_STRING:
		player_state.setState(key, data)


func set_state_arrayf(key : String, data : Array[float]):
	var array = JavaScriptBridge.create_object("Array")
	for f in data:
		array.push(f)
	player_state.setState(key, array)
	
