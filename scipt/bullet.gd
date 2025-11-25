extends Area2D

@export var speed: float = 600.0
var direction: Vector2 = Vector2(0, -1) # default ke atas

func _physics_process(delta):
	position += direction * speed * delta

	# auto delete jika keluar layar
	if position.y < -50 or position.y > 1500:
		queue_free()

func _ready():
	# connect body_entered untuk mendeteksi PhysicsBody2D seperti CharacterBody2D
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# cek apakah body adalah musuh (group) dan punya method take_damage
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		queue_free()
