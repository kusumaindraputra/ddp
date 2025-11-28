# scipt/enemy_shooter.gd
extends CharacterBody2D

@export var speed: float = 40.0
@export var hp: int = 4
@export var bullet_spawner_scene: PackedScene  # optional spawn spawner instance

func _ready() -> void:
	# if using PackedScene for spawner, instantiate and configure
	if bullet_spawner_scene:
		var sp = bullet_spawner_scene.instantiate()
		add_child(sp)
		sp.position = Vector2(0, 10)  # offset under enemy
		# configure pattern by exported variables on sp (inspector)
		# e.g., sp.pattern_type = "spiral"

func _physics_process(delta):
	velocity = Vector2(0, 1) * speed
	move_and_slide()

	# auto delete jika keluar layar
	if position.y > 1300:
		queue_free()
func take_damage(amount: int):
	hp -= amount
	if hp <= 0:
		die()

func die():
	queue_free()
