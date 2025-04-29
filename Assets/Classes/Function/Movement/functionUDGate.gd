extends Function


## Sends the particle up or down depending on value
class_name  FunctionUDGate


var dir = Vector2(0, 0)
var filter = 0


func _init():
	filter = Global.rng.randi_range(0, 1)
	if filter:
		sprite = preload("res://Assets/Sprites/oudgate_arrow.png")
	else:
		sprite = preload("res://Assets/Sprites/eudgate_arrow.png")
	pass


## The action the function performs
func activate(particle: Node):
	var pos
	if particle.value % 2 == filter:
		pos = Vector2(particle.loc.x, particle.loc.y + 1)
	else:
		pos = Vector2(particle.loc.x, particle.loc.y - 1)
	particle.setPos(check_bounds(pos, particle, particle.loc))
	pass
