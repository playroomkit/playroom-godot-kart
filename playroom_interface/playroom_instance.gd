
## encapsulates interfacing with the playroom javascript context.
## encapsulates playroom interface functions for cleaner calling/typing 

class_name PlayroomInstance
extends Node



# ----- FIELDS -----



# signals allow other nodes to listen for playroom callbacks

## emitted when the playroom host launches the game
signal coin_inserted(args)

## emitted when a new player joins
signal player_joined(args)



## reference to the playroom JS interface.
## prefer using encapsulated functions instead
@onready var playroom = JavaScriptBridge.get_interface("Playroom") :
	get: return playroom
	set(value): pass



# We will create js callables to send to playroom to trigger async behavior -
# ie. when a player loads into the game.
# An extra reference to these callables is kept just in case, to prevent the callable 
# from being refcount deleted (garbage collected)


# Our array of JS callables - to save from being deleted
var _js_callbacks : Array[JavaScriptObject]


## playroom player states
var player_states = [] :
	get : return player_states
	set(value) : pass



# ----- CALLBACKS -----



# -- JS Callbacks 


# called by playroom when the host has pressed launch and loaded the game
func _on_insert_coin(args):
	
	print("COIN INSERTED")
	coin_inserted.emit(args)


# called by playroom when a new player joins (including the host)
func _on_new_player_join(args):
	
	var state = args[0]
	print("PLAYER HAS JOINED: ", state.id)
	player_states.push_back(state)
	
	# populate new player data
	if playroom_is_host():
		print("SETTING SELF AS HOST")
		state.setState("host_player", playroom_my_player())
		print(state.getState("host_player"))
		# TODO for some reason can't get/set state from host player



# called by playroom when this player disconnects
func _on_disconnect(e):
	pass


# -- Godot Callbacks


func _ready():
	pass


func _process(delta):
	pass



# ----- PUBLIC -----



## launches playroom!
func start_playroom():
	_start_playroom()


# -- Playroom interface functions


## returns if the current context is the playroom host
func playroom_is_host() -> bool:
	return playroom.isHost()


## returns this context's player state object
func playroom_my_player():
	return playroom.myPlayer()



# ----- PRIVATE -----



# Our method for creating JS callbacks: 
# wraps a godot callable as a JS callable and logs it in our callback array
func _create_callback(callable : Callable):
	
	var callback = JavaScriptBridge.create_callback(callable)
	_js_callbacks.push_back(callback)
	
	return callback


# regsiters callbacks and initializes the playroom lobby
func _start_playroom():
	
	# populate initialization options
	var init_options = JavaScriptBridge.create_object("Object")
	
	# insert coin!
	# registers our callback for when the game launches
	playroom.insertCoin(init_options, _create_callback(_on_insert_coin))
	
	# register player join/leave callbacks
	playroom.onPlayerJoin(_create_callback(_on_new_player_join))
	playroom.onDisconnect(_create_callback(_on_disconnect))
