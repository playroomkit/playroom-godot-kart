
## the racetrack level.
## handles spawning and placement of cars.
## holds geometry


class_name TrackBase
extends Node3D


## will spawn cars at locations in order
@export var car_spawns : Array[Node3D]

# iterator for car_spawns
var cars_spawned = 0


## list of cars
@export var cars : Array[CarBase]


func add_car(car : CarBase):
	
	assert(car_spawns.size() >= cars_spawned, "not enough car spawns") 
	
	add_child(car)
	car.global_transform = car_spawns[cars_spawned].global_transform
	cars.push_back(car)
	cars_spawned += 1

