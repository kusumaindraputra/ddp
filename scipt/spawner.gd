extends Node2D

@export var enemy_basic_scene: PackedScene
@export var enemy_zigzag_scene: PackedScene
@export var enemy_shooter_scene: PackedScene
@export var spawn_interval: float = 1.5

func _ready():
	# tunggu satu frame supaya parent selesai setup (opsional)
	await get_tree().process_frame
	spawn_loop()

func spawn_loop() -> void:
	while true:
		spawn_enemy()
		await get_tree().create_timer(spawn_interval).timeout

func spawn_enemy() -> void:
	var pick = randi() % 3
	var enemy
	if pick == 0:
		enemy = enemy_shooter_scene.instantiate()
	elif pick == 1:
		enemy = enemy_shooter_scene.instantiate()
	else: 
		enemy = enemy_shooter_scene.instantiate()
	enemy.position = Vector2(randf_range(200, 200), -50)
	add_child.call_deferred(enemy)
