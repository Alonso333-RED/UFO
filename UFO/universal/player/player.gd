extends CharacterBody2D

var speed = 225

var min_x = -450
var max_x = 450
var min_y = -450
var max_y = 450

@export var max_health: int = 100
@export var bullet_scene: PackedScene
var health: int = max_health
var is_dead = false
var last_direction = Vector2.RIGHT

@onready var hp_indicator = $/root/Node2D/game_ui/CanvasLayer/controls_container/Label

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
	
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)
	
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		last_direction = input_vector
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO
	
func take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	$hit.play()
	hp_indicator.text = str(health)
	health = clamp(health, 0, max_health)
	if health == 0:
		is_dead = true
		get_tree().call_deferred("reload_current_scene")
		
func recover_health(amount: int) -> void:
	health += amount
	$recover_sound.play()
	health = clamp(health, 0, max_health)
	hp_indicator.text = str(health)
	
func _on_timer_timeout() -> void:
	if health < max_health:
		$regen.play()
		health += 1
		health = clamp(health, 0, max_health)
		hp_indicator.text = str(health)
		
func shoot():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)

	bullet.global_position = global_position
	bullet.direction = last_direction

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_pressed("shoot"):
		if $ShootTimer.is_stopped():
			shoot()
			$ShootTimer.start()

func _on_shoot_timer_timeout():
	if Input.is_action_pressed("shoot"):
		shoot()
	else:
		$ShootTimer.stop()
