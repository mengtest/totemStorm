extends KinematicActor

export(float) var fSpeed := 30.0
var iLife := 25
onready var nArea2d := $area2D
const scnGold := preload("res://scenes/gold.tscn")
const scnShieldRegen := preload("res://scenes/shieldRegen.tscn")
const scnEnemyDeath := preload("res://scenes/enemyDeathFx.tscn")


func _ready() -> void:
	add_to_group('Enemy')
	add_to_group('Actor')
	set_physics_process(true)
	
func _physics_process(_delta: float) -> void:
	if global.player == null:
		return
		
	var vMotion := Vector2()
	vMotion = -(self.global_position - global.player.global_position).normalized()
	$sprite.flip_h = (vMotion.x <= 0)
	
	if global.totem.nTmr.time_left < 1:
		vMotion = Vector2()
	
	vVelocity = vVelocity.linear_interpolate(vMotion * fSpeed, 0.05)
	vVelocity = move_and_slide(vVelocity)
	
func damage(iAmount) -> void:
	if !self.visible:
		return
		
	self.iLife -= iAmount
	if iLife <= 0:
		self.remove_from_group('Enemy')
		yield(get_tree(),"idle_frame")
		AudioManager.playSfx(AudioManager.sfxEnemyDeath)
		
		for _idx in range(10):
			var i = scnGold.instance()
			get_parent().add_child(i)
			i.global_position = self.global_position + 8*Vector2.ONE.rotated(rand_range(0,2*PI))
		
		for _idx in range(5):
			var j = scnShieldRegen.instance()
			get_parent().add_child(j)
			j.global_position = self.global_position + 8*Vector2.ONE.rotated(rand_range(0,2*PI))
		
		var k = scnEnemyDeath.instance()
		get_parent().add_child(k)
		k.global_position = self.global_position
		
		self.vVelocity = Vector2()
		$sprite.self_modulate.a = 0
		$sprShadow.self_modulate.a = 0
		$runParticles.emitting = false
		$collisionShape2D.disabled = true
		$area2D/collisionShape2D.disabled = true
		self.set_physics_process(false)
		nArea2d.queue_free()
		yield(get_tree().create_timer(10.0),"timeout")
		self.queue_free()


func _on_area2D_body_entered(body: Node) -> void:
	if body.is_in_group('Player'):
		body.damage(10)
		body.knockbackFrom(self.global_position)
	pass # Replace with function body.
