extends CharacterBody2D

@export var speed: float = 80.0
@export var zigzag_amplitude: float = 500.0
@export var zigzag_speed: float = 4.0
@export var hp: int = 2

var time := 0.0

func _physics_process(delta):
	time += delta

	var zig_x = sin(time * zigzag_speed) * zigzag_amplitude
	var direction = Vector2(zig_x, speed)

	velocity = direction
	move_and_slide()

	if position.y > 1300:
		queue_free()

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		queue_free()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var player = area.get_parent()  # Player adalah parent dari HurtBox
		if player.has_method("take_damage"):
			player.take_damage(1)
		queue_free()
