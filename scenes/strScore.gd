extends Label

var iShownScore := 0
var t := 0
func _ready() -> void:
	set_process(true)
	
func _process(_delta: float) -> void:
	t += 1
	if iShownScore < global.iScore:
		iShownScore += 1
	self.text = str(iShownScore)
