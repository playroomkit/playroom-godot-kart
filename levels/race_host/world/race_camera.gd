
## track camera -
## hovers a set offset away from the track.
## center of offset is the vector average of all cars

class_name RaceCamera
extends Camera3D


@export var track : TrackBase
@export var y_offset = 30.0
@export var z_offset = 20.0
@export var lerp_weight = 0.05


func _physics_process(delta):
	
	if track.cars.size() < 1: return
	
	# average of vectors
	var mid = Vector3.ZERO
	for car in track.cars:
		mid += car.global_position
	
	mid /= track.cars.size()
	
	# add offset
	mid.y += y_offset
	mid.z += z_offset
	
	# lerp towards target
	global_position = global_position.lerp(mid, lerp_weight)
