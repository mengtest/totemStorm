extends AnimatedSprite

func _ready() -> void:
	$particles2D.emitting = true
	self.z_index = 100
	self.play("default")

func _on_enemyDeathFx_animation_finished() -> void:
	self.self_modulate.a = 0
	yield(get_tree().create_timer(20.0),"timeout")
	self.queue_free()


func _on_enemyDeathFx_frame_changed() -> void:
	self.z_index -= 1
