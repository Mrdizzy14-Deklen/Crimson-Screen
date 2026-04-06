extends Control


@onready var progress_bar: ProgressBar = $ProgressBar


var target
var loading_finished: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = LoadManager.next_scene
	loading_finished = false
	ResourceLoader.load_threaded_request(target)

func _process(delta: float) -> void:
	var progress = []
	ResourceLoader.load_threaded_get_status(target, progress)
	progress_bar.value = progress[0] * 100
	
	if progress[0] == 1:
		if loading_finished:
			return
		loading_finished = true
		await get_tree().create_timer(1.0).timeout 
		var packed_scene = ResourceLoader.load_threaded_get(target)
		get_tree().change_scene_to_packed(packed_scene)
