extends Node2D


class_name Chip


const CHIP = preload("res://object.tscn") # Base scene
const DOWN_ARROW = [preload("res://Assets/Sprites/down_arrow.tres"), preload("res://Assets/Sprites/frame.tres")]


@onready var bottom_level_sprite: AnimatedSprite2D = $BottomLevel
@onready var top_level_sprite: AnimatedSprite2D = $TopLevel
@onready var wear_timer: Timer = $WearTimer
@onready var speech_timer: Timer = $SpeechTimer
@onready var speech_bubble: Sprite2D = $SpeechBubble
@onready var score_amount: RichTextLabel = $ScoreAmount


# Define dictionaries
const NAMES = ["Joe", "Bob"] ## Names possible for the chips
var MOODS = {
				"Aggressive":
					"Aggressive",
				} ## Personalities possible for the chips
var SPRITES = [[preload("res://Assets/Sprites/default.tres"), preload("res://Assets/Sprites/frame.tres")]] ## Sprites possible for the chips
var MOVE_FUNCTIONS = {
				"Down":
					FunctionDown,
				"Up":
					FunctionUp,
				"Left":
					FunctionLeft,
				"Right":
					FunctionRight,
				"UDSwitch":
					FunctionUDSwitch,
				"LRSwitch":
					FunctionLRSwitch,
				"ClockSwitch":
					FunctionClockSwitch,
				"UDGate":
					FunctionUDGate,
				"Cash":
					FunctionCash,
				} ## Movement functions possible for the chips
var VALUE_FUNCTIONS = {
				"Add":
					FunctionAdd,
				"Add1":
					FunctionAdd,
				"Add2":
					FunctionAdd,
				"Add3":
					FunctionAdd,
				"Add4":
					FunctionAdd,
				"Add5":
					FunctionAdd,
				"SignSwitch":
					FunctionSignSwitch,
				} ## Value functions possible for the chips


# Drag variables
var draggable = false ## If the chip is draggable by the mouse
var in_zone = false ## If inside the bounding box of a platform
var body_ref: Node2D ## The platform it belongs to
var offset: Vector2 ## The offset from the mouse when being dragged
var initial_pos: Vector2 ## The position it was in when originally clicked
var loc ## The position on the grid
var locked: String ## If locked to a spot/area
var lockedto: int ## Index locked to if locked
var glued: bool = false ## If the chip can be picked up

# Define customizability variables
var chip_name: String = ""
var mood
var sprite
var color: Color = Color(255, 255, 255)

# Functionality variables
var functions: Array ## All functions the chip performs
var dir: Vector2 = Vector2(0, 0) ## Where it moves particles
var val: int = 0 ## The amount of score it adds/subs
var durability: float = 20 ## Amount of particles the chip is able to handle
var wear: float = 0 ## The amount of current damage the chip has taken
var target_wear: float = 0 ## The amount the wear value is approaching
var cooling: int = 1 ## The efficiency of the chip
var invunerable: bool = false

# Determining wear rate of change
var cycle_data = []
var cycle_start_time = 0
var rate: float = 0
var cycle_wear = 0

# Personality variables
var speech = ""
var speech_seen: bool = true


## Creates a new chip
static func new_chip(preset: String = "", location = 0):
	
	var new_chip = CHIP.instantiate()
	
	match preset:
		"down_tile":
			new_chip.chip_name = "Down Plate"
			new_chip.mood = ""
			new_chip.functions.append(new_chip.MOVE_FUNCTIONS["Down"].new())
			new_chip.locked = "row"
			new_chip.lockedto = location.y
			new_chip.invunerable = true
			new_chip.sprite = DOWN_ARROW
			
		_:
			new_chip.random_chip()
	return new_chip


static func make_copy(old_chip: Chip):
	
	var new_chip = CHIP.instantiate()
	new_chip.chip_name = old_chip.chip_name
	new_chip.mood = old_chip.mood
	new_chip.sprite = old_chip.sprite
	
	# Set chip functions
	for i in old_chip.functions:
		new_chip.functions.append(i)
		if i.score_function:
			new_chip.val += i.amount
		if !i.score_function:
			new_chip.dir += i.dir
	new_chip.color = old_chip.color
	
	return new_chip


func _ready():
	bottom_level_sprite.sprite_frames = sprite[0]
	bottom_level_sprite.play()
	top_level_sprite.sprite_frames = sprite[1]
	top_level_sprite.play()
	wear_timer.wait_time = 0.1#Global.particle_move_time * 2
	if mood:
		speech_timer.wait_time = Global.rng.randf_range(5,120)
		speech_timer.start()
	Global.waveStart.connect(waveStart)
	Global.scorePoint.connect(waveEnd)
	Global.resetRates.connect(resetRate)
	
	if val > 0:
		score_amount.text = str("+", val)
	elif val < 0:
		score_amount.text = str(val)
	else:
		if mood:
			score_amount.text = "+-"
		else:
			score_amount.text = ""
 

## Generates a random chip
func random_chip():
	# Set chip customizations
	chip_name = NAMES[Global.rng.randi_range(0, NAMES.size() - 1)]
	mood = MOODS.values().pick_random()
	sprite = SPRITES[Global.rng.randi_range(0, SPRITES.size() - 1)]
	
	# Set chip functions
	var new_func = VALUE_FUNCTIONS.values().pick_random().new()
	functions.append(new_func)
	val += new_func.amount
	new_func = MOVE_FUNCTIONS.values().pick_random().new()
	functions.append(new_func)
	dir += new_func.dir
	color = Color(Global.rng.randf_range(0, 1), Global.rng.randf_range(0, 1), Global.rng.randf_range(0, 1))
	pass


func _process(delta: float) -> void:
	if !speech_seen:
		speech_bubble.visible = true
	else:
		speech_bubble.visible = false
	coolDown(delta)
	if draggable:
		speech_seen = true
		if !Global.has_info:
			Global.setinfo(self)
		if Input.is_action_just_pressed("click") and !glued:
			Global.resetRates.emit()
			Engine.time_scale = 0
			initial_pos = global_position
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
		
		if Global.is_dragging:
			if Input.is_action_pressed("click"):
				global_position = get_global_mouse_position() - offset
			elif Input.is_action_just_released("click"):
				
				Global.is_dragging = false
				var tween = get_tree().create_tween()
				if in_zone:
					if loc is Vector2:
						Global.grid[loc.x][loc.y] = self
					if loc is int:
						Global.hand[loc] = self
					if loc is String:
						if loc == "next_summon":
							Global.next_summon = self
					tween.tween_property(self, "global_position", body_ref.global_position, 0.15).set_ease(Tween.EASE_IN_OUT)
				else:
					tween.tween_property(self, "global_position", initial_pos, 0.15).set_ease(Tween.EASE_IN_OUT)
				Engine.time_scale = 1
	pass


func sendToHand(sendTo: int = -1):
	if sendTo == -1:
		sendTo = Global.findOpenHand()
	if sendTo != -1:
		Global.hand[sendTo] = self
		loc = sendTo
		global_position = Vector2(144 + 240 * sendTo, 936)
		return true
	else:
		return false

func _on_area_2d_mouse_entered() -> void:
	if not Global.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)
	pass


func _on_area_2d_mouse_exited() -> void:
	if not Global.is_dragging:
		draggable = false
		scale = Vector2(1, 1)
		Global.clearinfo()
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("droppable") and (body.taken == self or not body.taken) and !glued:
		if check_if_droppable(body):
			in_zone = true
			body.modulate = Color(Color.REBECCA_PURPLE, 1)
			body_ref = body
			body.taken = self
			loc = body.pos
	pass


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("droppable"):
		if body.taken == self:
			body.taken = null
			body.modulate = Color(Color.MEDIUM_PURPLE, 0.7)
			if loc is Vector2:
				if loc:
					Global.grid[loc.x][loc.y] = null
			elif loc != -1:
				Global.hand[loc] = null
	pass


## Checks if the object is locked to an area(body: Node2D)
func check_if_droppable(body: Node2D):
	var is_droppable = false
	match locked:
		"row":
			if "pos" in body and body.pos is Vector2:
				if body.pos.y == lockedto:
					is_droppable = true
		_:
			is_droppable = true
	if body.pos is Vector2:
		if dir.x < 0:
			if body.pos.x <= 0:
				is_droppable = false
		elif dir.x > 0:
			if body.pos.x >= Global.WIDTH - 1:
				is_droppable = false
		if body.pos == Vector2(0, 0):
			is_droppable = false
			
	return is_droppable


## Damages the chip
func wearDown(particle: Node):
	if !invunerable:
		if wear >= durability:
			Global.info_cycle_end.append(wear)
			self.queue_free()
		wear += particle.height
		modulate = Color(1, 1 - (wear/durability), 1 - (wear/durability), 1)
		if draggable:
			Global.setinfo(self)
	pass


## Cools the chip
func coolDown(delta):
	if draggable:
		Global.clearinfo()
		Global.setinfo(self)
	if wear >= cooling:
		wear -= cooling * delta
	else:
		wear = 0
	modulate = Color(1, 1 - (wear/durability), 1 - (wear/durability), 1)
	pass


## Triggered when a wave starts
func waveStart():
	cycle_start_time = Time.get_ticks_msec()
	if mood:
		Global.info_cycle_start.append(wear)
	cycle_data.clear()
	pass


## Triggered when a wave ends
func waveEnd():
	if mood:
		Global.info_cycle_end.append(wear)
	pass


func _on_wear_timer_timeout() -> void:
	cycle_data.append(wear - cycle_wear)
	if cycle_data.size() > 100:
		cycle_data.remove_at(0)
	var cycle_avg = 0
	for i in cycle_data:
		cycle_avg += i
	cycle_avg /= cycle_data.size()
	rate = 1000000 * ((cycle_avg)/2)/(Time.get_ticks_msec() - cycle_start_time)
	if draggable:
		Global.clearinfo()
		Global.setinfo(self)
	cycle_wear = wear
	pass


func resetRate():
	rate = 0
	cycle_data.clear()
	pass


func _speech_trigger() -> void:
	speech_timer.wait_time = Global.rng.randf_range(5,120)
	speech = "joe" # TEMP
	if draggable:
		Global.clearinfo()
		Global.setinfo(self)
	else:
		speech_seen = false
	await get_tree().create_timer(10.0).timeout 
	speech = ""
	if draggable:
		Global.clearinfo()
		Global.setinfo(self)
	speech_seen = true
	pass
