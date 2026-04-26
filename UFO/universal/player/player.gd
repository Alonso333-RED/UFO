extends CharacterBody2D

var speed = 225

var min_x = -450
var max_x = 450
var min_y = -450
var max_y = 450

@export var max_health: int = 100
@export var bullet_scene: PackedScene

var health: int
var is_dead = false

var shoot_cooldown = 0.2
var shoot_time = 0.0

@onready var hp_indicator = $/root/Node2D/game_ui/CanvasLayer/controls_container/Label

func _ready():
	health = max_health

@warning_ignore("unused_parameter")
func _physics_process(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if Input.is_action_pressed("ui_up_right"):
		input_vector = Vector2(1, -1)
	elif Input.is_action_pressed("ui_up_left"):
		input_vector = Vector2(-1, -1)
	elif Input.is_action_pressed("ui_down_right"):
		input_vector = Vector2(1, 1)
	elif Input.is_action_pressed("ui_down_left"):
		input_vector = Vector2(-1, 1)

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.y = clamp(global_position.y, min_y, max_y)


func _process(delta):
	# AIM con mouse
	var mouse_pos = get_global_mouse_position()
	var dir = mouse_pos - global_position
	rotation = dir.angle()

	# cooldown de disparo
	shoot_time -= delta

	if Input.is_action_pressed("shoot") and shoot_time <= 0:
		shoot()
		shoot_time = shoot_cooldown

func shoot():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)

	bullet.global_position = global_position

	var dir = (get_global_mouse_position() - global_position).normalized()

	var spread = deg_to_rad(6)
	var random_angle = randf_range(-spread, spread)

	bullet.direction = dir.rotated(random_angle)

# -------------------------
# VIDA
# -------------------------

func take_damage(amount: int) -> void:
	if is_dead:
		return

	health -= amount
	health = clamp(health, 0, max_health)

	$hit.play()
	hp_indicator.text = str(health)

	if health <= 0:
		is_dead = true
		get_tree().call_deferred("reload_current_scene")

func recover_health(amount: int) -> void:
	health += amount
	health = clamp(health, 0, max_health)

	$recover_sound.play()
	hp_indicator.text = str(health)

func _on_timer_timeout() -> void:
	if health < max_health:
		$regen.play()
		health += 1
		health = clamp(health, 0, max_health)
		hp_indicator.text = str(health)
