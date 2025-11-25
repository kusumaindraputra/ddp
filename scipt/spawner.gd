extends Node2D

@export var enemy_scene: PackedScene
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
	var e = enemy_scene.instantiate()
	# set posisi spawn (ubah sesuai ukuran layar)
	e.position = Vector2(randi_range(50, 450), -50)
	# tambahkan deferred supaya tidak kena 'parent busy' error
	get_tree().current_scene.call_deferred("add_child", e)
