extends Node2D


@onready var chip_cool_timer: Timer = $ChipCoolTimer
@onready var points: RichTextLabel = $CanvasLayer/Points
@onready var platforms: Node = $Platforms
@onready var chips: Node = $Chips
@onready var particles: Node = $Particles
@onready var spawner: Control = $CanvasLayer/Spawner
@onready var random_speech_timer: Timer = $RandomSpeechTimer


const PLATFORM = preload("res://platform.tscn")


func _ready() -> void:
	start()
	pass


func _process(delta):
	if Input.is_action_pressed("sendWave"):
		if !Global.computing:
			Global.computing = true
			newParticle()
		if Global.can_move:
			Global.move_particles(true)
			Global.can_move = false
	if !Global.computing and Global.difficulty == "Hard":
		Global.computing = true
		newParticle()
	pass


func start():
	setUpHand()
	setUpGrid()
	Global.connect("scorePoint", updateScore)
	points.text = str("[right]", Global.score, "[/right]")
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("newChip"):
		summonChip()


func updateScore():
	points.text = str("[right]", Global.score, "[/right]")
	pass



### Scene Setup Fucntions


## Sets up the breadboard
func setUpGrid(x: int = 9, y: int = 4):
	for i in x:
		Global.grid.append([])
		for j in y:
			newPlatform(Vector2((i) * 200 + 192 - 4*x, (j) * 200 + 120 - 4*y), Vector2(i, j))
			Global.grid[i].append(null)
	for i in y:
		var new_chip = newChip(Vector2(x - 1, i), Vector2((x - 1) * 200 + 192 - 4 * x, (i) * 200 + 120 - 4*y), "down_tile")
		Global.grid[x-1][i] = new_chip
	pass


func setUpHand():
	newPlatform(Vector2(144, 936), 0)
	newPlatform(Vector2(384, 936), 1)
	Global.hand.append(null)
	Global.hand.append(null)


### Object Generation Functions


func summonChip():
	var index = Global.findOpenHand()
	if index >= 0:
		var tempChip = newChip(null, Vector2(1920/2, 1080/2), "")
		tempChip.sendToHand(index)
	else:
		print_debug("No open hand")


## Generates a new chip (grid_location, global_position: Vector2, preset: String)
func newChip(loc, position: Vector2 = Vector2(0, 0), preset: String = "down_tile"):
	var new_chip = Chip.new_chip(preset, loc)
	chips.add_child(new_chip)
	new_chip.global_position = position
	return new_chip


## Generates a new platform (global_position: Vector2, grid_location: Vector2)
func newPlatform(loc: Vector2, _pos):
	var new_plat = PLATFORM.instantiate()
	platforms.add_child(new_plat)
	new_plat.global_position = loc
	new_plat.pos = _pos
	return new_plat


## Generates a new particle (value: int, grid_location: Vector2, spawn_pos: Vector2)
func newParticle(
				_val: int = 0, 
				_loc = null, 
				_target: Vector2 = Vector2(-156, 104)):
	var new_par = Particle.new_particle(_val, _loc, _target)
	particles.add_child(new_par)
	new_par.global_position = _target
	Global.waveStart.emit()
	pass


func _speech_trigger() -> void:
	random_speech_timer.wait_time = Global.rng.randf_range(15,30)
	if chips.get_child_count() > 4:
		var temp = chips.get_child(Global.rng.randi_range(4, chips.get_child_count() - 1))
		print_debug(temp.chip_name)
		temp._speech_trigger()
	pass
