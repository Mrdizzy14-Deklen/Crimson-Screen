extends Node


## Base function template
class_name  Function


var sprite = preload("res://Assets/Sprites/udswitch_arrow.png")


var score_function: bool = false


## The action the function performs
func activate(particle: Node) -> void:
	pass


## Checks if the target is in the grid
func check_bounds(target: Vector2, particle: Node, current_pos: Vector2):
	var new_target: Vector2 = target
	if target.x < 0:
		new_target.x = 0
	elif target.x >= Global.WIDTH:
		new_target.x = Global.WIDTH - 1
	if new_target == current_pos:
		new_target = Vector2(0, 1)
	return new_target
