
## vroom vroom

class_name CarBase
extends RigidBody3D


enum DRIVE_STATE {GAS, BRAKE, REVERSE, IDLE}

@export var acceleration_impulse = 10
@export var steering_velocity = 5.0
@export var slide_damp_force = 5.0
@export var slide_damp_mult = 1.0

@onready var mesh = $MeshInstance3D

## determines physics behavior of car
var drive_state = DRIVE_STATE.IDLE
var steering_state = 0

## what the controller is telling us
var drive_input = DRIVE_STATE.IDLE
var steering_input = 0
var steering_velocity_coefficient = 40


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
		print("CAR GASSING")
		apply_central_force(forwards * acceleration_impulse)
	
	# steering
	var speed = linear_velocity.length()
	angular_velocity.y = (steering_velocity * -steering_state * speed) / steering_velocity_coefficient
	
	# slide damp
	_slide_dampening()


# ----- PUBLIC -----


func set_color(color : Color):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.material_override = mat


# -- Control Commands

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


# dampens tangential velocity
func _slide_dampening():
	
	# get tangential velocity component (right facing)
	var right = transform.basis.x
	var tangential_velocity = linear_velocity.dot(right)
	
	# apply force tangentially (- right facing) proportional to tanvel
	apply_central_force(-right * slide_damp_force * slide_damp_mult * tangential_velocity)
	
