extends Function


## Adds to the particle's value
class_name  FunctionAdd


var amount


func _init():
	score_function = true
	amount = Global.rng.randi_range(1, 13)
	if amount == 13:
		sprite = preload("res://Assets/Sprites/sub.png")
		amount = -13
	elif amount > 0:
		sprite = preload("res://Assets/Sprites/add.png")
	pass


## The action the function performs
func activate(particle: Node):
	particle.value += amount
	pass
