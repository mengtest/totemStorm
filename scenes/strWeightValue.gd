extends Label

func _ready() -> void:
	set_process(true)
	
func _process(_delta: float) -> void:
	if global.player != null:
		self.text = str(global.player.fWeight)
