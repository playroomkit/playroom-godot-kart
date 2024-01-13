
## vroom vroom

class_name CarBase
extends RigidBody3D


enum DRIVE_STATE {GAS, BRAKE, REVERSE, IDLE}

@export var acceleration_impulse = 100

var drive_state = DRIVE_STATE.IDLE



# ----- CALLBACKS -----



func _physics_process(delta):
	
	var forwards = transform.basis.z
	
	if drive_state == DRIVE_STATE.REVERSE:
		apply_central_force( - forwards * acceleration_impulse)
	elif drive_state == DRIVE_STATE.GAS:
		apply_central_force(forwards * acceleration_impulse)
	


func press_gas():
	drive_state = DRIVE_STATE.GAS


func press_brake():
	drive_state = DRIVE_STATE.BRAKE


func press_reverse():
	drive_state = DRIVE_STATE.REVERSE
