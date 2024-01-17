extends Area3D
@onready var gpu_particles_3d = $CollisionShape3D/MeshInstance3D/GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	gpu_particles_3d.emitting = true
