extends Button

func _ready() -> void:
	set_process(true)
	
func _process(_delta: float) -> void:
	if global.player != null:
		get_node("../../../../../..").visible = global.player.bDead
		if global.player.bDead:
			get_tree().paused = true

func _on_btnRestart_pressed() -> void:
	AudioManager.playSfx(AudioManager.sfxBtnPress)
	global.iScore = 0
	var _v = get_tree().reload_current_scene()
	pass # Replace with function body.
