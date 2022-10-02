extends StaticBody2D
class_name Totem

const scnBullet := preload("res://scenes/bullet.tscn")
const scnBolt := preload("res://scenes/sprBoltFx.tscn")
onready var nSprEye := $sprEye
onready var nTmr := $timer
onready var nLayerTint := $canvasLayer
func _ready() -> void:
	global.totem = self
	set_process(true)
	
func _process(_delta: float) -> void:
	update()
	
	if global.player != null:
		nSprEye.position = nSprEye.position.linear_interpolate(64 * (global.player.global_position - self.global_position).normalized(), 0.05)
		nSprEye.rotation = (global.player.global_position - self.global_position).angle()

func _draw() -> void:
	draw_arc(Vector2(),
		96.0,
		0.0,
		range_lerp(nTmr.time_left,0,10,2*PI,0),
		360,
		Color('#333c57'),
		16.0,
		false
	)
	draw_arc(Vector2(),
		96.0,
		0.0,
		range_lerp(nTmr.time_left,0,10,2*PI,0),
		360,
		Color('#f4f4f4'),
		8.0,
		false
	)

func _on_timer_timeout() -> void:
	set_process(false)
	nLayerTint.visible = true
	global.enemySpawner.nTmr.stop()
	for node in get_tree().get_nodes_in_group('Actor'):
		node.set_physics_process(false)
	
	for node in get_tree().get_nodes_in_group('Actor'):
		if node.vVelocity.length() > 16:
			var i = scnBolt.instance()
			i.global_position = node.global_position - Vector2(0,64)
			get_parent().add_child(i)
			
			if global.playerCamera != null:
				global.playerCamera.mediumShake()
			
			node.vVelocity = Vector2()
			if node.is_in_group('Player'):
				node.rawDamage(100)
			else:
				node.damage(100)
			#shoot(node)
			yield(get_tree().create_timer(0.01),"timeout")
	yield(get_tree().create_timer(0.3),"timeout")
	
	for node in get_tree().get_nodes_in_group('Actor'):
		node.set_physics_process(true)
	
	nLayerTint.visible = false
	nTmr.start()
	global.enemySpawner.nTmr.start()
	set_process(true)
	global.getFaster()

func shoot(nTarget:Node2D) -> void:
	var i := scnBullet.instance() as Bullet
	i.iDamage = 100
	i.fSpeed *= 4
	i.nParent = self
	i.nTarget = nTarget
	i.pause_mode = Node.PAUSE_MODE_PROCESS
	i.global_position = self.global_position
	i.vDirection = -(self.global_position - nTarget.global_position).normalized()
	get_parent().add_child(i)

