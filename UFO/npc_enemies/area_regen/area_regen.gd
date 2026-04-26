extends Area2D

var hp_recovered: int = 5
var heal_time: int = 0
@onready var visual: Sprite2D = $Sprite2D

func _ready():
	randomize()
	rotation_degrees = randi() % 360
	set_random_position()
	$spawn_sound.play()
	heal_time = randi_range(1, 4)
	visual.visible = true
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(heal_time).timeout
	queue_free()


func set_random_position():
	position = Vector2(
		randf_range(-500, 500),
		randf_range(-500, 500)
	)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.recover_health(hp_recovered)
		queue_free()
