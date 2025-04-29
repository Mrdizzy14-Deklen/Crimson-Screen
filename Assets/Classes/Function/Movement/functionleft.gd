extends Function


## Sends the particle left
class_name  FunctionLeft


var dir = Vector2(-1, 0)


func _init():
	sprite = preload("res://Assets/Sprites/l_arrow.png")
	pass


## The action the function performs
func activate(particle: Node):
	particle.setPos(check_bounds(Vector2(particle.loc.x - 1, particle.loc.y), particle, particle.loc))
	particle.dir = -1
	pass
