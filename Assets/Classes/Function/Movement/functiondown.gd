extends Function


## Sends the particle down
class_name  FunctionDown


var dir = Vector2(0, 1)


func _init():
	sprite = preload("res://Assets/Sprites/d_arrow.png")
	pass


## The action the function performs
func activate(particle: Node):
	particle.setPos(check_bounds(Vector2(particle.loc.x, particle.loc.y + 1), particle, particle.loc))
	pass
