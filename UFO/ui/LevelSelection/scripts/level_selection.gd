extends Control

@export var level_list: LevelList

@onready var level_preview = $LevelPreview
@onready var name_label      = $VBoxContainer/Name
@onready var diff_label      = $VBoxContainer/Difficulty
@onready var desc_label      = $VBoxContainer/Descripcion
@onready var back_btn        = $BackLevel
@onready var next_btn        = $NextLevel

var current_index := 0

func _ready():
	update_ui()
	
	back_btn.pressed.connect(_on_Back_pressed)
	next_btn.pressed.connect(_on_Next_pressed)
	level_preview.pressed.connect(_on_Play_pressed)

func update_ui():
	var lvl = level_list.levels[current_index]
	if lvl.preview_path != "":
		var tex : Texture2D = load(lvl.preview_path)
		level_preview.icon = tex
	else:
		level_preview.icon = null

	level_preview.text = ""
	name_label.text = lvl.name
	diff_label.text = ["*","**","***","****","*****"][lvl.difficulty]
	desc_label.text = lvl.description

func _on_Back_pressed():
	current_index = (current_index - 1 + level_list.levels.size()) % level_list.levels.size()
	update_ui()

func _on_Next_pressed():
	current_index = (current_index + 1) % level_list.levels.size()
	update_ui()

func _on_Play_pressed():
	var lvl = level_list.levels[current_index]
	get_tree().change_scene_to_file(lvl.scene)
