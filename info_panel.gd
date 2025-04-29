extends Control


@onready var v_box: VBoxContainer = $Panel/VBoxContainer
@onready var heat: ProgressBar = $Panel/Heat
@onready var efficiency: RichTextLabel = $Panel/Efficiency
@onready var speech_box: RichTextLabel = $Panel/SpeechBox
@onready var score_amount: RichTextLabel = $Panel/ScoreAmount
@onready var total_efficiency: RichTextLabel = $Panel2/TotalEfficiency


var name_label
var mood_label
var functions


func _ready():
	Global.efficiency_val_submit.connect(waveEnd)
	pass


func _process(delta: float) -> void:
	if Global.has_info:
		if!Global.info_updated:
			if !Global.info_invunerable:
				heat.visible = true
				#efficiency.visible = true
				heat.value = (Global.info_wear/Global.info_durability) * 100
			else:
				heat.visible = false
				#efficiency.visible = false
			# Clear the v box
			for c in v_box.get_children():
				c.queue_free()
			
			# Add the name label
			name_label = Label.new()
			if Global.info_name:
				name_label.text = "Name: " + Global.info_name
			else:
				name_label.text = "Name: ???"
			Global.info_updated = true
			
			v_box.add_child(name_label)
			
			# Add the mood label
			if Global.info_mood:
				mood_label = Label.new()
				mood_label.text = "Mood: " + Global.info_mood
				v_box.add_child(mood_label)
			else:
				if mood_label:
					mood_label.queue_free()
					
			
			# Add the functions box
			functions = HBoxContainer.new()
			v_box.add_child(functions)
			for i in Global.info_func:
				var sprite = TextureRect.new()
				sprite.texture = i.sprite
				functions.add_child(sprite)
			
			if Global.info_speech:
				speech_box.visible = true
				speech_box.add_theme_color_override("default_color", (Global.info_color))
				speech_box.text = str("\"", Global.info_speech, "\"")
			else:
				speech_box.visible = false
			
			if Global.info_amount > 0:
				score_amount.text = str("+", Global.info_amount)
			elif Global.info_amount < 0:
				score_amount.text = str(Global.info_amount)
			else:
				if Global.info_mood:
					score_amount.text = "+-"
				else:
					score_amount.text = ""
					
			# Set the rate
			#efficiency.text = str("[right]", Global.round_place(Global.info_rate, 1), "°/s")
	else:
		heat.visible = false
		efficiency.visible = false
		speech_box.visible = false
		score_amount.text = ""
		# Clear the v box if not hovering
		for c in v_box.get_children():
			c.queue_free()
		

func waveEnd():
	total_efficiency.text = str("[center]", Global.round_place(Global.find_average(Global.info_cycle_start) - Global.find_average(Global.info_cycle_end), 1), "°")
	pass
