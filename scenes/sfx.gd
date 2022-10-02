extends AudioStreamPlayer

func _ready() -> void:
	pass
	
func _on_sfx_finished() -> void:
	yield(get_tree().create_timer(10.0),"timeout")
	self.queue_free()
