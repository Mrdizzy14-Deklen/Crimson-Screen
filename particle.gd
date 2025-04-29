extends Node2D


class_name Particle


const PARTICLE = preload("res://particle.tscn")
@onready var value_label: RichTextLabel = $Value


var value: int = 0 ## The point value of the particle
var dir: int = 1 ## The direction the particle is moving
var loc ## Position on the grid
var target: Vector2 ## The target global position
var hasBeenTriggered: bool = false ## Checks if first move was triggered (Only matters for non easy modes)
var moving: bool = false ## If the particle is currently inbetween destinations
var height: int = 1 ## The amount of strain the particle puts on chips

var tween


## Creates a new particle
static func new_particle(
						_val: int, 
						_loc, 
						_target: Vector2 = Vector2(-156, 104)):
	
	var new_part = PARTICLE.instantiate()
	
	new_part.value = _val
	new_part.loc = _loc
	new_part.target = _target
	
	return new_part


func _ready() -> void:
	if Global.difficulty == "Easy":
		Global.moveParticles.connect(_move)
	if Global.difficulty != "Easy":
		_move()
	pass


func _process(delta: float) -> void:
	value_label.text = str("[center]", value)


## Tweens the particle to the next target
func move_to_target():
	if !moving:
		moving = true
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", target, Global.particle_move_time).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	await Engine.time_scale > 0
	moving = false
	Global.can_move = true
	tween = null
	if Global.difficulty != "Easy":
		_move()
	if loc.y >= Global.HEIGHT:
		Global.cash_particle(self, 1)
	if loc.y < 0:
		Global.cash_particle(self, -1)
		
		
	pass


## Sets the position on the grid (position: Vector2)
func setPos(pos: Vector2):
	loc = pos
	target.x = (200 * loc.x) + 156
	target.y = (200 * loc.y) + 104
	height = pos.y + 1
	pass


## Handles the particles movement
func _move(triggered = false) -> void:
	#if (Global.difficulty == "Easy") or (Global.difficulty != "Easy" and !hasBeenTriggered) or !triggered:
		#hasBeenTriggered = true
		if loc == null:
			setPos(Vector2(0, 0))
		else:
			if Engine.time_scale > 0 and !moving and loc.y < Global.HEIGHT:
				if Global.grid[loc.x][loc.y]: 
					Global.grid[loc.x][loc.y].wearDown(self)
					for i in Global.grid[loc.x][loc.y].functions:
						if i and i.has_method("activate"):
							i.activate(self)
							if i.score_function:
								for j in height - 1:
									i.activate(self)
				else: 
					default_move()
		await Engine.time_scale > 0
		move_to_target()
		pass


func default_move():
	var index = loc.x + dir
	while index >= -1 and index <= Global.grid.size():
		if index >= 0 and index < Global.grid.size():
			if Global.grid[index][loc.y]: 
				setPos(Vector2(index, loc.y))
				break
		else:
			dir *= -1
		index += dir
		
	pass
