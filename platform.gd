extends StaticBody2D


var taken: Node2D ## If the spot is taken by a chip
var pos ## The position on the grid/in hand


func _ready() -> void:
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)
	pass


func _process(delta: float) -> void:
	if Global.is_dragging:
		visible = true
	else:
		visible = false
	pass
