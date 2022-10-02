extends Area2D

export(float) var fValue := 10.0
var nTarget:Player = null

func _ready() -> void:
	set_process(true)
	
func _process(_delta: float) -> void:
	if nTarget == null:
		return
	
	self.global_position = self.global_position.linear_interpolate(nTarget.global_position, 0.2)
	if (self.global_position - nTarget.global_position).length() < 8:
		AudioManager.playSfx(AudioManager.sfxEnemyDeath)
		nTarget.iGold += int(fValue)
		self.queue_free()

func _on_gold_body_entered(body: Node) -> void:
	if body is Player:
		nTarget = body
