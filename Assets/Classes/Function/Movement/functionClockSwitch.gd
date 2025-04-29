extends Function


## Sends the particle up, right, down, left in a repeating motion
class_name  FunctionClockSwitch


var dir = Vector2(0, 0)
var switch = Vector2(0, -1)
var step = 0 ## The current step in the clock


func _init():
	sprite = preload("res://Assets/Sprites/cswitch_arrow.png")
	pass


## The action the function performs
func activate(particle: Node):
	particle.setPos(check_bounds(Vector2(particle.loc.x + switch.x, particle.loc.y + switch.y), particle, particle.loc))
	if switch.x:
		particle.dir = switch.x
	match step:
		0:
			switch = Vector2(1, 0)
		1:
			switch = Vector2(0, 1)
		2:
			switch = Vector2(-1, 0)
		3:
			switch = Vector2(0, -1)
			step = -1
	step += 1
	pass
