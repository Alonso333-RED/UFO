extends Button

func _ready():
	button_down.connect(_on_down)
	button_up.connect(_on_up)

func _on_down():
	Input.action_press("shoot")

func _on_up():
	Input.action_release("shoot")
