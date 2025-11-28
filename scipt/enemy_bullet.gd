# scipt/enemy_bullet.gd
extends Area2D

@export var speed: float = 240.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# connect collision signal once
	self.area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

	# cleanup margin based on 480x640
	if global_position.x < -64 or global_position.x > 480 + 64 \
	or global_position.y < -96 or global_position.y > 640 + 96:
		queue_free()

func _on_area_entered(area: Node) -> void:
	# assumes player HurtBox Area2D is in group "player"
	if area.is_in_group("player"):
		# get parent player node if needed
		var target = area.get_parent()
		if target and target.has_method("take_damage"):
			target.take_damage(1)
		queue_free()
