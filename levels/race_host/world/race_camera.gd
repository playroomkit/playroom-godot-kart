extends Camera3D


@export var track : TrackBase
@export var y_offset = 30.0
@export var z_offset = 20.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	
	if track.cars.size() < 1: return
	
	var mid = Vector3.ZERO
	for car in track.cars:
		mid += car.global_position
	
	mid /= track.cars.size()
	
	mid.y += y_offset
	mid.z += z_offset
	
	global_position = mid
