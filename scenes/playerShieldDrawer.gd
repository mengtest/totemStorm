extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true)
func _process(delta: float) -> void:
	update()
func _draw() -> void:
	draw_arc(Vector2(),
		24.0,
		0.0,
		range_lerp(get_parent().fShownShield,0,get_parent().fMaxShield,0,2*PI),
		360,
		Color.white,
		2.0,
		false
	)
