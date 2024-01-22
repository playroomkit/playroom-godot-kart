
## vroom vroom

class_name CarBase
extends RigidBody3D


enum DRIVE_STATE {GAS, BRAKE, REVERSE, IDLE}

signal lap_passed(gate)

@export var acceleration_impulse = 25
@export var steering_velocity = 1.5
@export var steering_time_mult = 0.1 ## increases steering over time
@export var slide_damp_force = 5.0
@export var slide_damp_mult = 1.0
@export var flip_delay = 0.5 ## seconds

@onready var mesh = $MeshInstance3D
@onready var dust_particles = $DustParticles
@onready var bonk_particles = $BonkParticles
@onready var collision_raycast = $CollisionRaycast

## determines physics behavior of car
var drive_state = DRIVE_STATE.IDLE
var steering_state = 0
var grounded = true
var locked = false ## controlled by racetrack (for countdown)

## what the controller is telling us
var drive_input = DRIVE_STATE.IDLE
var steering_input = 0


# ----- CALLBACKS -----


func _ready():
	pass


func _physics_process(delta):
	
	# manage inputs
	
	_process_input_flags(delta)
	
	# then manage physics behavior
	
	# no driving if in the air
	if !grounded: return
	
	# propulsion
	
	var forwards = transform.basis.z
	var up = transform.basis.y
	
	# acceleration
	if drive_state == DRIVE_STATE.REVERSE:
		if !locked: apply_central_force( - forwards * acceleration_impulse)
		dust_particles.emitting = true
	elif drive_state == DRIVE_STATE.GAS:
		if !locked: apply_central_force(forwards * acceleration_impulse)
		dust_particles.emitting = true
	else:
		dust_particles.emitting = false
	
	# steering
	var speed = linear_velocity.length()
	var velocity = steering_velocity * -steering_state * speed
	if drive_state == DRIVE_STATE.REVERSE: velocity = -velocity
	angular_velocity.y = velocity
	
	# slide damp
	_slide_dampening()


func _on_body_entered(body):
	if !body.is_in_group("road"):
		_bonk()


func _on_body_exited(body):
	pass


func _on_flipped_area_entered(area):
	_flip_car()


func _on_lap_detector_area_entered(area):
	print("lap detector area detected...")
	if area.is_in_group("lap"):
		print("lap detector, detected LAP!")
		lap_passed.emit(area.gate_number)


func _on_track_hug_area_body_entered(body):
	if body.is_in_group("road"): 
		grounded = true
		print("on road")


func _on_track_hug_area_body_exited(body):
	if body.is_in_group("road"): 
		grounded = false
		print("off road")



# ----- PUBLIC -----


func set_color(color : Color):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.set_surface_override_material(1, mat)


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
	steering_input += steering_time_mult


func steer_left():
	steering_input -= steering_time_mult


func steer_neutral():
	steering_input = 0



# ----- PRIVATE -----



func _process_input_flags(delta):
	drive_state = drive_input
	steering_state = steering_input * delta
	
	# map steering state
	steering_state = min(1, steering_state)
	steering_state = max(-1, steering_state)


# dampens tangential velocity
func _slide_dampening():
	
	# get tangential velocity component (right facing)
	var right = transform.basis.x
	var tangential_velocity = linear_velocity.dot(right)
	
	# apply force tangentially (- right facing) proportional to tanvel
	apply_central_force(-right * slide_damp_force * slide_damp_mult * tangential_velocity)


func _flip_car():
	await get_tree().create_timer(flip_delay).timeout
	transform.basis.y = Vector3(0,1,0)
	transform = transform.orthonormalized()


# when hit
func _bonk():
	bonk_particles.emitting = true
	# heh
	Input.vibrate_handheld(250)
