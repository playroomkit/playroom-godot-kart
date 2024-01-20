
## just fires all these particles at ready to get the lag over with

class_name ParticlePreloader
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is GPUParticles3D: child.emitting = true
