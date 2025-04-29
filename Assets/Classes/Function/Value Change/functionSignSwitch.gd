extends Function


## Switch the particle's sign
class_name  FunctionSignSwitch


var amount = 0


func _init():
	sprite = preload("res://Assets/Sprites/sign.png")
	pass


## The action the function performs
func activate(particle: Node):
	particle.value *= -1
	pass
