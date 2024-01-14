
## vroom vroom

class_name CarBase
extends RigidBody3D


enum DRIVE_STATE {GAS, BRAKE, REVERSE, IDLE}

@export var acceleration_impulse = 10
@export var steering_torque = 5

## determines physics behavior of car
var drive_state = DRIVE_STATE.IDLE
var steering_state = 0

## what the controller is telling us
var drive_input = DRIVE_STATE.IDLE
var steering_input = 0


# ----- CALLBACKS -----



func _physics_process(delta):
	
	# manage inputs
	
	_process_input_flags()
	_clear_input_flags()
	
	# then manage physics behavior
	
	var forwards = transform.basis.z
	var up = transform.basis.y
	
	# acceleration
	if drive_state == DRIVE_STATE.REVERSE:
		apply_central_force( - forwards * acceleration_impulse)
	elif drive_state == DRIVE_STATE.GAS:
		apply_central_force(forwards * acceleration_impulse)
	
	# steering
	apply_torque(up * steering_torque * steering_state)


# ----- PUBLIC -----


# -- CONTROL COMMANDS

func press_gas():
	drive_input = DRIVE_STATE.GAS


func press_brake():
	drive_input = DRIVE_STATE.BRAKE


func press_reverse():
	drive_input = DRIVE_STATE.REVERSE


func press_idle():
	drive_input = DRIVE_STATE.IDLE


func steer_right():
	steering_input = 1


func steer_left():
	steering_input = -1


func steer_neutral():
	steering_input = 0



# ----- PRIVATE -----



func _process_input_flags():
	drive_state = drive_input
	steering_state = steering_input


func _clear_input_flags():
	drive_input = DRIVE_STATE.IDLE
	steering_input = 0
