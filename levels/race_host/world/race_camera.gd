
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
	
	_track_mycar()
	#_track_car_follow()


func _track_mycar():
	
	if track.my_racer == null : return
	
	var pos = track.my_racer.car.global_position
	
	# add offsets
	pos.y += y_offset
	pos.z += z_offset
	
	global_position = global_position.lerp(pos, lerp_weight)


func _track_car_follow():
	
	if track.my_racer == null : return
	
	var trans = track.my_racer.car.follow_camera.global_transform
	global_transform = global_transform.interpolate_with(trans, lerp_weight)


func _track_midpoint():
	
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
