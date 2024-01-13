
## for interfacing with the playroom javascript context.
## encapsulates playroom interface functions for cleaner calling/typing.
## launches playroom in stream mode (for phone kart) 

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


## playroom player states - stored as keys
var player_states = {} :
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
	
	# add state to states
	var state = args[0]
	print("PLAYER HAS JOINED: ", state.id)
	player_states[state] = true
	
	# populate new player data
	if playroom_is_host():
		print("SETTING SELF AS HOST")
		state.setState("host_player", playroom_my_player())
		print(state.getState("host_player"))
		# TODO for some reason can't get/set state from host player
	
	# log callback to listen for player quitting
	state.onQuit(_create_callback(_on_player_quit))


# called by playroom when a player quits
func _on_player_quit(player_state):
	player_states.erase(player_state)


# called by playroom when this player disconnects # TODO doesn't work?
func _on_disconnect(error):
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


## returns if current context is the stream screen
func playroom_is_stream_screen():
	return playroom.isStreamScreen()


# this does not work
## takes a godot callable to fire when the player's state is set true (see api).
## COROUTINE - will return control when state is set
func playroom_await_player_state( player_state, \
								  state_key : String, \
								  callback : Callable):
	
	var js_callback = _create_callback(callback)
	await playroom.waitForPlayerState(player_state, state_key, js_callback)

# this works
func playroom_await_test(state, key):
	await playroom.waitForPlayerState(state, key)



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
	
	# launch in stream mode
	#init_options.streamMode = true
	
	# insert coin!
	# registers our callback for when the game launches
	playroom.insertCoin(init_options, _create_callback(_on_insert_coin))
	
	# register player join/leave callbacks
	playroom.onPlayerJoin(_create_callback(_on_new_player_join))
	#playroom.onDisconnect(_create_callback(_on_disconnect))
