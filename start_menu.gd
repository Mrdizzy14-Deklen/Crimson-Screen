extends Control


@onready var menu_button: MenuButton = $VBoxContainer/MenuButton


var difficulty = "Medium"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_button.get_popup().id_pressed.connect(_on_menu_button_pressed)
	pass


func _on_menu_button_pressed(id: int) -> void:
	match id:
		0:
			difficulty = "Easy"
		1:
			difficulty = "Medium"
		2:
			difficulty = "Hard"
	menu_button.text = difficulty
	pass


func _on_start_button_pressed() -> void:
	Global.difficulty = difficulty
	LoadManager.changeSceneTo("res://main.tscn")
	pass
