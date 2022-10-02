extends KinematicActor
class_name Player


const scnBullet := preload("res://scenes/bullet.tscn")
const scnFxAttack := preload("res://scenes/fxAttackEffect.tscn")
onready var nArea2d := $area2D
onready var nRunParticles := $runParticles
onready var nRunParticles2 := $runParticles2
export(Curve) var lerpCurve2d:Curve=Curve.new()
var bDead := false
var iGold := 0 setget setGold
func setGold(iValue) -> void:
	global.iScore += iValue
#	fWeight += iValue * global.fGoldWeight
#	fLerpConstant = lerpCurve2d.interpolate(fWeight/100.0)
	#iGold = min (100, iValue)

var strAnim := 'idle'
var fMaxShield := 100.0
var fShield := 0.0 setget setShield
func setShield(fValue) -> void:
#	if bRegenerating:
#		set_physics_process(false)
#		return
#	if fValue <= 0.0:
#		bRegenerating = true
	fShield = clamp(fValue, 0.0, fMaxShield)
		
var fShownShield := 0.0
var bRegenerating := false
var fLerpConstant := 0.1

var fWeight := 0.0
var fSpeed := 165.0#220.0
var t := 0


func _ready() -> void:
	global.player = self
	resetShield()
	set_process(true)
	set_physics_process(true)

func _process(_delta: float) -> void:
	fShownShield = lerp(fShownShield, fShield, 0.1)
	if !self.is_physics_processing():
		$animationPlayer.stop(false)
	if !$animationPlayer.is_playing() and self.is_physics_processing():
		$animationPlayer.play(strAnim)
	update()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed('ui_debug'):
		self.iGold += 10
	
	t+=1
	if $animationPlayer.current_animation != strAnim:
		$animationPlayer.play(strAnim)
	
	
	var vMotion := Vector2()
	vMotion.x = -1 if Input.is_action_pressed('ui_left') else 1 if Input.is_action_pressed('ui_right') else 0
	vMotion.y = -1 if Input.is_action_pressed('ui_up') else 1 if Input.is_action_pressed('ui_down') else 0
	$sprite.flip_h = (vMotion.x == -1) if vMotion.x != 0 else $sprite.flip_h
	vMotion = vMotion.normalized()
	
	strAnim = 'run' if vMotion != Vector2() else 'idle'
	
	nRunParticles.emitting = vMotion !=  Vector2()
	nRunParticles2.emitting = vMotion !=  Vector2()
	
	vVelocity = vVelocity.linear_interpolate(vMotion * fSpeed, fLerpConstant * (2 if vMotion.length() > 0 else 1))
	vVelocity = move_and_slide(vVelocity)
	
	if Input.is_action_just_pressed('ui_lmb') or\
		(Input.is_action_pressed('ui_lmb') and t%5==0):
		shoot()

func _draw() -> void:
	draw_arc(Vector2(),
		24.0,
		0.0,
		range_lerp(fShownShield,0,fMaxShield,0,2*PI),
		360,
		Color.white,
		4.0,
		false
	)
	draw_arc(Vector2(),
		24.0,
		0.0,
		range_lerp(fShownShield,0,fMaxShield,0,2*PI),
		360,
		Color('#73eff7'),
		2.0,
		false
	)

func rawDamage(iAmount) -> void:
	AudioManager.playSfx(AudioManager.sfxPlayerHit)
	self.fShield -= iAmount
	if fShield <= 0.0:
		set_physics_process(false)

func damage(iAmount) -> void:
	AudioManager.playSfx(AudioManager.sfxPlayerHit)
	frameFreeze()
	for body in nArea2d.get_overlapping_bodies():
		if body.is_in_group('Enemy'):
			body.knockbackFrom(self.global_position, 2560)
	if fShield <= 0.0:
		bDead = true
		set_physics_process(false)
	self.fShield -= iAmount
	
	#self.fShield -= min(fShield, iAmount)
	
func knockbackFrom(_v:Vector2,_a:float=0.0) -> void:
	pass

func shoot() -> void:
	AudioManager.playSfx(AudioManager.sfxPlayerAttack)
	
	var j = scnFxAttack.instance()
	j.global_position = self.global_position -(self.global_position - get_global_mouse_position()).normalized() * 16
	j.rotation = (self.global_position - get_global_mouse_position()).angle() + PI 
	get_parent().add_child(j)
	
	var i := scnBullet.instance() as Bullet
	i.nParent = self
	i.global_position = self.global_position
	i.vDirection = -(self.global_position - get_global_mouse_position()).normalized()
	get_parent().add_child(i)

func resetShield() -> void:
	fShield = fMaxShield

func frameFreeze() -> void:
	Engine.time_scale = 0.05
	yield(get_tree().create_timer(0.8 * Engine.time_scale),"timeout")
	Engine.time_scale = 1
