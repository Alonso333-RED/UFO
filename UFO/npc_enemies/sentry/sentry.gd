extends Node2D

@onready var turret = $turret
@onready var muzzle = $turret/muzzle
@onready var bullet_scene = preload("res://npc_enemies/sentry/Bullet.tscn")

var max_hitpoints = 25
var is_dead = false
var hitpoints = max_hitpoints

func _ready():
	set_random_position()

func set_random_position():
	position = Vector2(
		randf_range(-500, 500),
		randf_range(-500, 500)
	)
	
func get_closest_player():
	var players = get_tree().get_nodes_in_group("player")

	var closest = null
	var min_dist = INF

	for p in players:
		if not is_instance_valid(p):
			continue

		var dist = global_position.distance_to(p.global_position)

		if dist < min_dist:
			min_dist = dist
			closest = p
	return closest
	
var target = null
var timer = 0
var shoot_timer = 0

func _process(delta):
	timer -= delta
	shoot_timer -= delta

	if timer <= 0:
		timer = 0.2
		target = get_closest_player()

	if target:
		var dir = target.global_position - turret.global_position
		turret.rotation = dir.angle() + PI / 2

		if shoot_timer <= 0:
			shoot()
			shoot_timer = 0.1
			
func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = muzzle.global_position

	var dir = (target.global_position - muzzle.global_position).normalized()

	var spread = deg_to_rad(6)
	var random_angle = randf_range(-spread, spread)

	bullet.direction = dir.rotated(random_angle)
	
func take_damage(amount):
	hitpoints -= amount

	if hitpoints <= 0:
		queue_free()
