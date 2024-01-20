
## controls an individual racer for the host, processing async client input.
## also stores data for that racer/player.
## WARNING may occasionally await client!

# TODO make generic?

class_name RacerPuppet
extends Node



# ----- FIELDS -----



signal lap_passed(racer : RacerPuppet)

@export_category("Preloads")
@export var car_template : PackedScene

var playroom : PlayroomInstance
var track_base : TrackBase 
var player_state = null
var joystick = null
var car : CarBase



# ----- CALLBACKS -----



func _ready():
	playroom = Playroom.instance


func _process(delta):
	
	_process_joy_inputs()


func _on_car_lap_passed():
	print("Racer received new lap! passing")
	lap_passed.emit(self)


## called by host as a pseudo-constructor
func setup(player : PlayroomPlayer, track : TrackBase):
	
	player_state = player.player_state
	track_base = track
	joystick = player.joystick
	
	# spawn car
	car = car_template.instantiate()
	track_base.add_car(car)
	car.lap_passed.connect(_on_car_lap_passed)
	lock_car()
	
	# set car color
	var color = Color(player_state.getProfile().color.hexString)
	car.set_color(color)


func lock_car():
	car.locked = true


func unlock_car():
	car.locked = false



# ----- PRIVATE -----



# process joystick inputs!
func _process_joy_inputs():

	if joystick == null: 
		print("RACER PUPPET NO JOY")
		return
	
	var dpad = joystick.dpad()
	
	if joystick.isPressed("gas"): 		
		car.press_gas()
	elif joystick.isPressed("brake"): 	car.press_reverse()
	else: 								car.press_idle()
	
	if dpad.x == "left": 	car.steer_left()
	elif dpad.x == "right": car.steer_right()
	else: 					car.steer_neutral()
