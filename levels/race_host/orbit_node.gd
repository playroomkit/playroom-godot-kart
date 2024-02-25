extends Node3D

@export var speed = -0.2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(speed * delta)
