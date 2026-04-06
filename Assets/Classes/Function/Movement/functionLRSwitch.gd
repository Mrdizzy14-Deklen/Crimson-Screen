extends Function


## Sends the particle left or right alternating
class_name  FunctionLRSwitch


var dir = Vector2(0, 0)
var switch = -1


func _init():
	sprite = preload("res://Assets/Sprites/lrswitch_arrow.png")
	pass


## The action the function performs
func activate(particle: Node):
	particle.setPos(check_bounds(Vector2(particle.loc.x + switch, particle.loc.y), particle, particle.loc))
	particle.dir = switch
	switch *= -1
	pass
