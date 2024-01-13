
class_name CarBase
extends RigidBody3D


@export var acceleration_impulse = 100

var gas = false
var reverse = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	
	var forewards = transform.basis.z
	
	if reverse:
		apply_central_force( - forewards * acceleration_impulse)
	elif gas:
		apply_central_force(forewards * acceleration_impulse)
	
	
