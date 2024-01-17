
## the racetrack level

class_name TrackBase
extends Node3D



## assume sibling of cars
@export var car_spawn : Node3D


## list of cars
@export var cars : Array[CarBase]


func add_car(car : CarBase):
	add_child(car)
	car.transform = car_spawn.transform
	cars.push_back(car)

