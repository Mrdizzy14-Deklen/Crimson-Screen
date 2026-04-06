extends Node


signal moveParticles()
signal waveStart
signal scorePoint
signal resetRates
signal efficiency_val_submit


var rng = RandomNumberGenerator.new()


const BASE_SPEED = 2
const WIDTH = 9
const HEIGHT = 4


var grid = [] ## The chips on the board
var hand = [] ## The chips in the player's hand
var next_summon: Chip ## The next chip that can be summoned

var score: int = 0
var difficulty = "Easy"

var particle_move_time = 0.25


var is_dragging = false
var dragging: Node2D

## Checks if a particle is in the system
var computing = false
var can_move = true


# Info for the hovered chip
var has_info: bool = false
var info_name: String = "???"
var info_mood: String = "???"
var info_func: Array
var info_durability: float
var info_wear: float
var info_rate: float = 0
var info_speech: String = ""
var info_color: Color = Color(255, 255, 255)
var info_amount: int = 0
var info_invunerable = true
var info_updated = false

# Calculating efficiency
var info_cycle_start = []
var info_cycle_end = []


func print_grid():
	print_debug(grid)


func move_particles(triggered = false):
	moveParticles.emit(triggered)


func cash_particle(particle: Node, multiple: int):
	score += particle.value * multiple
	# Limit score to [-666, 666]
	if abs(score) > 666:
		score = -666 * sign(score)
	particle.queue_free()
	scorePoint.emit()
	efficiency_val_submit.emit()
	computing = false
	info_cycle_start.clear()
	info_cycle_end.clear()


func findOpenHand():
	var index = null
	for i in range(hand.size()):
		if hand[i] == null:
			index = i 
			break
	if index != null:
		return index
	else:
		return -1


func setinfo(chip: Chip):
	info_updated = false
	has_info = true
	info_name = chip.chip_name
	info_mood = chip.mood
	for f in chip.functions:
		info_func.append(f)
	info_durability = chip.durability
	info_wear = chip.wear
	info_rate = chip.rate
	info_speech = chip.speech
	info_color = chip.color
	info_amount = chip.val
	info_invunerable = chip.invunerable


func clearinfo():
	info_updated = false
	has_info = false
	info_name = ""
	info_mood = "null"
	info_func.clear()
	info_durability = 0
	info_wear = 0
	info_rate = 0
	info_speech = ""
	info_color = Color(1, 1, 1)
	info_amount = 0
	info_invunerable = true


func round_place(num, places):
	return (round(num*pow(10,places))/pow(10,places))


func find_average(numbers: Array):
	if numbers.size():
		var sum = 0
		for n in numbers:
			sum += n
		return sum / numbers.size()
	else:
		return 0
