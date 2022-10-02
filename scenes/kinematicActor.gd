extends KinematicBody2D
class_name KinematicActor

var vVelocity := Vector2()

func _ready() -> void:
	add_to_group('Actor')

func knockbackFrom(vPosition:Vector2, fAmount:float = 1280.0) -> void:
	vVelocity = fAmount * (global_position - vPosition).normalized()

