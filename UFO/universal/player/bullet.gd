extends Area2D

@export var speed := 1000.0
@export var damage := 40
var direction := Vector2.RIGHT

func _process(delta):
	position += direction * speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
		
func _on_body_entered(body):
	var enemy = body.get_parent()

	if enemy.is_in_group("enemy_npc"):
		if enemy.has_method("take_damage"):
			enemy.take_damage(damage)
			queue_free()
