extends Label


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true)
func _process(_delta: float) -> void:
	self.text = "FINAL SCORE:\n" + str(global.iScore)
