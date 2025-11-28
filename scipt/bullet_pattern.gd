# scipt/bullet_pattern.gd
extends Node2D

@export var bullet_scene: PackedScene
@export var pattern_type: String = "spiral"  # spiral, ring, fan, aimed, wave
@export var fire_rate: float = 0.08          # seconds between shots (depending on pattern)
@export var bullets_per_wave: int = 12       # for fan/ring
@export var angle_step_deg: float = 10.0     # for fan
@export var spiral_speed_deg: float = 6.0    # how much angle increases per shot (spiral)
@export var bullet_speed: float = 240.0
@export var ring_count: int = 24
@export var wave_amplitude: float = 40.0
@export var wave_freq: float = 6.0           # frequency for wave bullets
@export var aimed_spread_deg: float = 8.0    # for slight spread around aimed

var _timer: Timer
var _current_angle_deg: float = 0.0
var _wave_time: float = 0.0

func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = false
	_timer.wait_time = fire_rate
	add_child(_timer)
	_timer.start()
	_timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	match pattern_type:
		"spiral":
			_spawn_spiral()
		"ring":
			_spawn_ring()
		"fan":
			_spawn_fan()
		"aimed":
			_spawn_aimed()
		"wave":
			_spawn_wave()
		_:
			_spawn_aimed()

func _instance_bullet(dir: Vector2) -> void:
	if bullet_scene == null:
		return
	var b = bullet_scene.instantiate()
	# set direction & speed
	b.direction = dir.normalized()
	b.speed = bullet_speed
	# spawn safe (deferred)
	get_tree().current_scene.call_deferred("add_child", b)
	b.global_position = global_position

# patterns
func _spawn_spiral() -> void:
	_current_angle_deg += spiral_speed_deg
	var dir = Vector2.RIGHT.rotated(deg_to_rad(_current_angle_deg))
	_instance_bullet(dir)

func _spawn_ring() -> void:
	for i in range(ring_count):
		var angle = (i / float(ring_count)) * TAU
		var dir = Vector2(cos(angle), sin(angle))
		_instance_bullet(dir)

func _spawn_fan() -> void:
	# centered downwards; compute start angle so fan is symmetric around down
	var mid = bullets_per_wave / 2.0 - 0.5
	var base = deg_to_rad(90) # downwards
	for i in range(bullets_per_wave):
		var a = base + deg_to_rad((i - mid) * angle_step_deg)
		_instance_bullet(Vector2(cos(a), sin(a)))

func _spawn_aimed() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	var to_player = (player.global_position - global_position).normalized()
	# optional spread: spawn several with small angles
	var half = int(max(1, round(aimed_spread_deg / 2.0)))
	_instance_bullet(to_player)

func _spawn_wave() -> void:
	# spawn a bullet downward with wave offset added in its script (or compute here)
	var dir = Vector2.DOWN
	var b = bullet_scene.instantiate()
	b.direction = dir
	b.speed = bullet_speed
	# tell bullet to behave wave-like (set exported properties)
	b.set("is_wave", true)
	b.set("wave_amplitude", wave_amplitude)
	b.set("wave_frequency", wave_freq)
	get_tree().current_scene.call_deferred("add_child", b)
	b.global_position = global_position
