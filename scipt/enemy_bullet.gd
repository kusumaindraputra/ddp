extends Area2D

@export var speed = 300.0
var direction = Vector2.ZERO

func _physics_process(delta):
	position += direction * speed * delta

	if position.y > 1500 or position.y < -200:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		var player_parent = area.get_parent()  # player_parent adalah parent dari HurtBox
		if player_parent.has_method("take_damage"):
			player_parent.take_damage(1)
		queue_free()
