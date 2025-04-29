extends Control


@onready var cost: RichTextLabel = $Panel/Cost
@onready var panel: Panel = $Panel


var next_chip: Chip


func _ready():
	next_chip = Chip.new_chip()
	panel.add_child(next_chip)
	next_chip.loc = "next_summon"
	next_chip.glued = true
	next_chip.global_position = Vector2(860 + 192/2, 300 + 192/2)
	pass


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("spawnMenu"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		cost.text = str("[center]Cost: ")


func _on_button_button_down() -> void:
	if get_parent().get_parent().has_method("summonChip"):
		var summoned_chip = Chip.make_copy(next_chip)
		get_parent().get_parent().get_child(0).add_child(summoned_chip)
		summoned_chip.sendToHand()
	pass
