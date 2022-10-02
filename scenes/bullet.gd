extends Area2D
class_name Bullet

var nParent = null
var nTarget = null
var iDamage := 1
var fSpeed := 600.0
var vDirection := Vector2()
var bDestroy := false
onready var nTmr := $timer
onready var nCollisionShape := $collisionShape2D
const scnHitFx := preload("res://scenes/hitFx.tscn")

func _ready() -> void:
	vDirection = vDirection.normalized()
	self.rotation = vDirection.angle()
	set_process(true)

func _process(delta: float) -> void:
	if bDestroy:
		set_process(false)
		self.visible = false
		nCollisionShape.disabled = true
		nTmr.start()
		
	self.global_translate(vDirection * fSpeed * delta)

func _on_visibilityNotifier2D_screen_exited() -> void:
	bDestroy = true
	
func _on_timer_timeout() -> void:
	self.queue_free()

func destroy() -> void:
	var i = scnHitFx.instance()
	i.global_position = self.global_position
	get_parent().add_child(i)
	self.queue_free()

func _on_bullet_body_entered(body: Node) -> void:
	if body == nParent:
		return
	if (nTarget == null) or (nTarget == body):
		if body is StaticBody2D:
			destroy()
		elif body.is_in_group('Enemy'):
			if body.has_method('damage'):
				body.damage(self.iDamage)
				body.knockbackFrom(self.global_position, 32)
			destroy()
