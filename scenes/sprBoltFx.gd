extends AnimatedSprite

func _ready() -> void:
	play("default")
	pass
	
func _on_sprBoltFx_animation_finished() -> void:
	self.self_modulate.a = 0
	yield(get_tree().create_timer(10.0),"timeout")
	self.queue_free()

func _on_sprBoltFx_frame_changed() -> void:
	self.z_index -= 1
