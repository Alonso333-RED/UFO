extends CharacterBody2D

var speed = 225

var min_x = -450
var max_x = 450
var min_y = -450
var max_y = 450

@export var max_health: int = 1000
@export var bullet_scene: PackedScene

var health: int
var is_dead = false

var shoot_cooldown = 0.1
var shoot_time = 0.0

# -------------------------
# INPUT ABSTRACTO
# -------------------------
var move_input := Vector2.ZERO
var aim_input := Vector2.RIGHT
var last_aim_dir := Vector2.RIGHT
var shooting := false


# UI
@onready var hp_indicator = $/root/Node2D/game_ui/CanvasLayer/exit_button/Label


func _ready():
	health = max_health


# -------------------------
# MOVIMIENTO
# -------------------------
@warning_ignore("unused_parameter")
func _physics_process(delta):
	var input_vector := Vector2.ZERO

	# PC movement
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# override móvil (joystick)
	if move_input.length() > 0.1:
		input_vector = move_input

	if input_vector.length() > 0.1:
		velocity = input_vector.normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.y = clamp(global_position.y, min_y, max_y)


# -------------------------
# LOOP PRINCIPAL
# -------------------------
func _process(delta):
	update_aim()
	update_shooting()

	# rotación hacia aim
	if aim_input.length() > 0.01:
		rotation = aim_input.angle()

	# cooldown
	shoot_time -= delta

	if shooting and shoot_time <= 0:
		shoot()
		shoot_time = shoot_cooldown


# -------------------------
# AIM SYSTEM (FIX DEFINITIVO)
# -------------------------
func update_aim():
	
	var ui = get_node("/root/Node2D/game_ui")
	if ui.aim_using_joystick:
		return

	var dir = get_global_mouse_position() - global_position

	if dir.length() > 0.01:
		aim_input = dir.normalized()
		last_aim_dir = aim_input
	else:
		aim_input = last_aim_dir

func set_aim_input(dir: Vector2):
	if dir.length() > 0.1:
		last_aim_dir = dir.normalized()

	aim_input = last_aim_dir


# -------------------------
# SHOOT SYSTEM
# -------------------------
func update_shooting():
	# PC input
	if not OS.has_feature("mobile"):
		shooting = Input.is_action_pressed("shoot")
		

func set_shooting_input(b: bool):
	shooting = b


# -------------------------
# MOVIMIENTO DESDE JOYSTICK
# -------------------------
func set_move_input(v: Vector2):
	move_input = v


# -------------------------
# DISPARO
# -------------------------
func shoot():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)

	bullet.global_position = global_position

	var dir = aim_input

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
