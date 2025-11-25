extends CharacterBody2D


@export var speed = 250.0

func _physics_process(delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	velocity = input_vector.normalized() * speed
	move_and_slide()

@export var bullet_scene: PackedScene
@export var fire_cooldown := 0.2
var can_fire := true

func _process(delta):
	if Input.is_action_pressed("shoot") and can_fire:
		shoot()

func shoot():
	can_fire = false
	var b = bullet_scene.instantiate()
	b.position = self.position
	get_tree().current_scene.add_child(b)

	# cooldown
	await get_tree().create_timer(fire_cooldown).timeout
	can_fire = true

var hp := 5

func take_damage(amount):
	hp -= amount
	print("Player HP:", hp)
	if hp <= 0: die()

func die(): 
	print("PLAYER DEAD")
	get_tree().reload_current_scene()
