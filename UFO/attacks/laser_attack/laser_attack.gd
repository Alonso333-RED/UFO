extends Area2D

var warn_time : int
var attack_time : int
@export var damage_per_attack := 1
@export var seconds_per_attack := 0.1
var attacking := false
var players_in_area := []
@onready var warn_visual = $warn_sprite
@onready var attack_visual = $attack_sprite

func _ready():
	randomize()
	rotation_degrees = randi() % 360
	set_random_position()
	warn_time = randi_range(1,4)
	attack_time = randi_range(1,2)
	warn_visual.visible = true
	attack_visual.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	start_warning()
	
func set_random_position():
	position = Vector2(
		randf_range(-500, 500),
		randf_range(-500, 500)
	)
	
func start_warning():
	await get_tree().create_timer(warn_time).timeout
	start_attack()
	
func start_attack():
	$attack_sound.play()
	warn_visual.visible = false
	attack_visual.visible = true
	attacking = true
	attack()
	
func attack():
	var elapsed_time := 0.0
	while attacking and elapsed_time < attack_time:
		await get_tree().create_timer(seconds_per_attack).timeout
		elapsed_time += seconds_per_attack
		for body in players_in_area:
			if is_instance_valid(body) and body.is_in_group("player"):
				body.take_damage(damage_per_attack)
	attacking = false
	queue_free()
					
func _on_body_entered(body):
	if body.is_in_group("player"):
		if not players_in_area.has(body):
			players_in_area.append(body)
			
func _on_body_exited(body):
	if body.is_in_group("player"):
		players_in_area.erase(body)
