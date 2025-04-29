extends Function


## Sends the particle up or down alternating
class_name  FunctionUDSwitch


var dir = Vector2(0, 0)
var switch = -1


func _init():
	sprite = preload("res://Assets/Sprites/udswitch_arrow.png")
	pass


## The action the function performs
func activate(particle: Node):
	particle.setPos(check_bounds(Vector2(particle.loc.x, particle.loc.y + switch), particle, particle.loc))
	switch *= -1
	pass
