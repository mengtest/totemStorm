extends Node2D

const arrScnEnemies := [
	preload("res://scenes/enemy1.tscn"),
	preload("res://scenes/enemy2.tscn"),
]

onready var nTmr := $timer

func _ready() -> void:
	global.enemySpawner = self

func _on_timer_timeout() -> void:
	spawnEnemy()
	
func spawnEnemy() -> void:
	#var i = arrScnEnemies[randi() % arrScnEnemies.size()].instance()
	var i = arrScnEnemies[0].instance() if randf() > 0.05 else arrScnEnemies[1].instance()
	i.global_position = 400 * Vector2.ONE.rotated(rand_range(0, 2*PI))
	add_child(i)

func getFaster() -> void:
	nTmr.wait_time *= 0.90
	nTmr.wait_time = max(nTmr.wait_time, 0.1)
