extends Node

@export var attacks : Array[EnemyData] = []

var spawn_rate : float = 1.0
var spawn_accumulator : float = 0.0
var time_elapsed : float = 0.0
var total_weight : float = 0.0

func _ready():
	total_weight = 0.0
	for data in attacks:
		if data.rarity <= 0.0:
			push_error("rarity debe ser mayor a 0 en todos los ataques")
		total_weight += 1.0 / data.rarity
		
func _process(delta: float):
	if attacks.size() == 0:
		return
		
	time_elapsed += delta
	spawn_rate = 1.0 + (time_elapsed * 0.1)
	spawn_accumulator += spawn_rate * delta
	var to_spawn : int = int(floor(spawn_accumulator))
	
	if to_spawn > 0:
		spawn_accumulator -= to_spawn
		for i in to_spawn:
			spawn_attack()
			
func spawn_attack():
	var data = pick_attack_data()
	if data == null:
		return
	
	var instance = data.scene.instantiate()
	add_child(instance)
	
func pick_attack_data() -> EnemyData:
	if total_weight <= 0.0:
		return null
	var r := randf() * total_weight
	var cumulative := 0.0
	
	for data in attacks:
		cumulative += 1.0 / data.rarity
		if r <= cumulative:
			return data
	return null
