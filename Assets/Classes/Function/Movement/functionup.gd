extends Function


## Sends the particle up
class_name  FunctionUp


var dir = Vector2(0, -1)


func _init():
	sprite = preload("res://Assets/Sprites/u_arrow.png")
	pass


## The action the function performs
func activate(particle: Node):
	particle.setPos(check_bounds(Vector2(particle.loc.x, particle.loc.y - 1), particle, particle.loc))
	pass
