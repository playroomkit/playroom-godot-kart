
## controls an individual racer for the host, processing async client input.
## also stores data for that racer/player.
## WARNING may occasionally await client!
## updates client player_states with race data (car positioning).
## if marked as remote, will attempt to sync car position with provided data.


# TODO make generic?

class_name RacerPuppet
extends Node



# ----- FIELDS -----



signal lap_passed(racer : RacerPuppet, gate : int)

@export_category("Networking")
@export var remote = false
@export var transform_lerp_weight = 0.1
@export var push_force = 5.0

@export_category("Preloads")
@export var car_template : PackedScene

var playroom : PlayroomInstance
var track_base : TrackBase 
var player_state = null
var joystick = null
var car : CarBase

var goal_position : Vector3 # pulled from player state if is remote
var goal_transform : Transform3D

## this racer is the racer of the current player
var my_racer = false



# ----- CALLBACKS -----



func _ready():
	playroom = Playroom.instance


func _physics_process(delta):
	_process_joy_inputs()
	_process_keyboard_inputs()
	_update_player_states()


func _on_car_lap_passed(gate):
	print("Racer received new lap! passing")
	lap_passed.emit(self, gate)


func _on_car_left_track():
	track_base.respawn_car(car)



## called by host as a pseudo-constructor
func setup(player : PlayroomPlayer, track : TrackBase):
	
	player_state = player.player_state
	track_base = track
	joystick = player.joystick
	
	# spawn car
	car = car_template.instantiate()
	track_base.add_car(car)
	car.lap_passed.connect(_on_car_lap_passed)
	car.left_track.connect(_on_car_left_track)
	lock_car()
	
	# set car color
	var color = Color(player_state.getProfile().color.hexString)
	car.set_color(color)
	
	print("racer set up: ", player.player_state.id)


func lock_car():
	car.lock_car()


func unlock_car():
	car.unlock_car()



# ----- PRIVATE -----



# process joystick inputs!
func _process_joy_inputs():

	if joystick == null: 
		print("RACER PUPPET NO JOY")
		return
	
	var dpad = joystick.dpad()
	
	if joystick.isPressed("gas"): 		car.press_gas()
	elif joystick.isPressed("brake"): 	car.press_reverse()
	else: 								car.press_idle()
	
	if dpad.x == "left": 	car.steer_left()
	elif dpad.x == "right": car.steer_right()
	else: 					car.steer_neutral()


# process keyboard inputs from playerstate (overrides joystick)
func _process_keyboard_inputs():
	if player_state == null: return
	
	if player_state.getState("up_input"): 	  car.press_gas()
	elif player_state.getState("down_input"): car.press_reverse()
	#else: 									  car.press_idle()
	
	if player_state.getState("right_input"):  car.steer_right()
	elif player_state.getState("left_input"): car.steer_left()
	#else: 									  car.steer_neutral()
	
	# idle state carries over from joy (allows both to give input for now)


# update player states
func _update_player_states():
	if player_state == null: return
	
	if playroom.playroom_is_host():
		_push_player_states()
	else:
		_pull_player_states()
		_sync_car_pos()


# push information from host to playerstate
func _push_player_states():
	player_state.setState("car_transform", var_to_str(car.global_transform))


# pull data from playerstate
func _pull_player_states():
	var str = player_state.getState("car_transform")
	if str == null: return
	goal_transform = str_to_var(player_state.getState("car_transform"))


# currently just lerps to pos
# TODO do this with forces on a PID?
func _sync_car_pos():
	car.global_transform = car.global_transform.interpolate_with( \
								goal_transform, transform_lerp_weight)
	#
	#var to = goal_transform.origin - car.global_position
	#car.apply_force(to.normalized() * push_force)
