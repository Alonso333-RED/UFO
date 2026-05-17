extends Area2D

@export var speed := 1000.0
@export var damage := 40
var direction := Vector2.RIGHT

func _process(delta):
	position += direction * speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
