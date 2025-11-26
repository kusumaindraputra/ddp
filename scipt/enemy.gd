extends CharacterBody2D

@export var speed: float = 60.0
@export var hp: int = 3

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


@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player == null: return
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var player_parent = area.get_parent()  # Player adalah parent dari HurtBox
		if player_parent.has_method("take_damage"):
			player_parent.take_damage(1)
		queue_free()
