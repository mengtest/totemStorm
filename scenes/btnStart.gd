extends Button

func _ready() -> void:
	get_tree().paused = true

func _on_btnStart_pressed() -> void:
	AudioManager.playSfx(AudioManager.sfxBtnPress)
	get_tree().paused = false
	get_node("../../../../../..").queue_free()
