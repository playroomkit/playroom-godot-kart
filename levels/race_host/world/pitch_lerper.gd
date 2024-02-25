extends AudioStreamPlayer3D

var pitch_target = 1.0
var lerp_weight = 0.1

func _process(delta):
	pitch_scale = lerpf(pitch_scale, pitch_target, lerp_weight)
