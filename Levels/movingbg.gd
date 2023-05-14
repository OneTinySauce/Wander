extends ParallaxLayer

@export var speed = -5.0
var stopped = false

func _process(delta):
	if stopped:
		speed = move_toward(speed, 0, delta * 5)
	
	self.motion_offset.x += speed * delta

func stop_motion():
	stopped = true
