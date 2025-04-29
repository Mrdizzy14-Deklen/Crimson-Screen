extends Function


## Cashes in the particle
class_name  FunctionCash


var dir = Vector2(0, 0)
var type: int = 1


func _init():
	type = Global.rng.randi_range(0, 1)
	if type:
		sprite = preload("res://Assets/Sprites/p_cash.png")
	else:
		sprite = preload("res://Assets/Sprites/n_cash.png")
	pass


## The action the function performs
func activate(particle: Node):
	if type:
		Global.cash_particle(particle, 1)
	else:
		Global.cash_particle(particle, -1)
	pass
