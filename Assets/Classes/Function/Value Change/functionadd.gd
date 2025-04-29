extends Function


## Adds to the particle's value
class_name  FunctionAdd


var amount


func _init():
	score_function = true
	amount = Global.rng.randi_range(-13, 13)
	while amount < 1 and amount != -13:
		amount = Global.rng.randi_range(1, 12)
	if amount > 0:
		sprite = preload("res://Assets/Sprites/add.png")
	else:
		sprite = preload("res://Assets/Sprites/sub.png")
	pass


## The action the function performs
func activate(particle: Node):
	particle.value += amount
	pass
