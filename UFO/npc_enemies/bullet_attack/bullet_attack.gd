extends Area2D

@export var damage_per_attack := 5
var speed : int
var speed_pool = [225, 450, 675, 900]
const AREA_HALF_SIZE = 500
const LINE_LENGTH = 2500
var end_position : Vector2
var dir : Vector2

func _ready():
	randomize()
	$attack_sound.play()
	speed = speed_pool[randi() % speed_pool.size()]

	var center = Vector2(
		randf_range(-AREA_HALF_SIZE, AREA_HALF_SIZE),
		randf_range(-AREA_HALF_SIZE, AREA_HALF_SIZE),
	)

	var angle = randf_range(0.0, PI * 2.0)
	dir = Vector2(cos(angle), sin(angle)).normalized()

	@warning_ignore("integer_division")
	var half_len = LINE_LENGTH / 2
	var start_point = center - dir * half_len
	var opposite_point = center + dir * half_len

	if randi() % 2 == 0:
		position = start_point
		end_position = opposite_point
	else:
		position = opposite_point
		dir = -dir
		end_position = start_point

	rotation = dir.angle() - PI/2

	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position += dir * speed * delta

	if (position - end_position).length() <= speed * delta:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage_per_attack)
		queue_free()
