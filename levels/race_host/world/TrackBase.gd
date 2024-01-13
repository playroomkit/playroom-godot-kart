
## the racetrack level

class_name TrackBase
extends Node3D



## assume sibling of cars
@export var car_spawn : Node3D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_car(car : CarBase):
	add_child(car)
	car.transform = car_spawn.transform

