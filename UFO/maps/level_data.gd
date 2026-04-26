extends Resource
class_name LevelData

@export var preview_path: String
@export var name: String
@export_multiline var description: String
@export_enum("*", "**", "***", "****", "*****") var difficulty: int
@export var scene: String
