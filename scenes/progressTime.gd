extends TextureProgress

func _ready() -> void:
	set_process(true)
func _process(_delta: float) -> void:
	self.value = global.totem.nTmr.wait_time - global.totem.nTmr.time_left
