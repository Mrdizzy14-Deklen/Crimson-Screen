extends Node


var next_scene = null


func changeSceneTo(target: String):
	next_scene = target
	get_tree().change_scene_to_packed(load("res://loading_screen.tscn"))
