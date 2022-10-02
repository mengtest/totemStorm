extends Node

func _ready() -> void:pass

# Thanks to https://www.youtube.com/watch?v=44YpRF5FZDc
func frameFreeze() -> void:
	Engine.time_scale = 0.05
	yield(get_tree().create_timer(0.8 * Engine.time_scale),"timeout")
	Engine.time_scale = 1

const fGoldWeight:=0.1 #kg

var player = null
var totem = null
var enemySpawner = null
var playerCamera = null
var iScore := 0

func getFaster() -> void:
	if enemySpawner != null:
		enemySpawner.getFaster()
