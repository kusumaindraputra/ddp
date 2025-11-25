extends CharacterBody2D

@export var speed: float = 40.0
@export var fire_rate: float = 1.5
@export var bullet_scene: PackedScene
@export var hp: int = 3

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	shoot_loop()

func _physics_process(delta):
	velocity = Vector2(0, speed)
	move_and_slide()

	if position.y > 1300:
		queue_free()

func shoot_loop() -> void:
	while true:
		if player:
			shoot()
		await get_tree().create_timer(fire_rate).timeout

func shoot():
	var b = bullet_scene.instantiate()
	b.global_position = global_position
	b.direction = (player.global_position - global_position).normalized()
	get_tree().current_scene.add_child(b)

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		queue_free()
