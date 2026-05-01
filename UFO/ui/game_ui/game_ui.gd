extends Control

@onready var player = $"../Player"
@onready var aim_joystick = $"CanvasLayer/controls_container2/VirtualJoystickPlus"

var use_joystick_on_pc := true   # activar joystick en PC (debug)
var joystick_active := false     # indica si el joystick está en uso


func _ready():
	aim_joystick.analogic_changed.connect(_on_aim_changed)


@warning_ignore("unused_parameter")
func _process(delta):
	# le dice al player quién está controlando
	player.using_joystick = joystick_active


@warning_ignore("unused_parameter")
func _on_aim_changed(value, distance, angle, angle_clockwise, angle_counter):

	# en PC solo funciona si activas debug
	if not OS.has_feature("mobile") and not use_joystick_on_pc:
		return

	# si el joystick se está moviendo
	if distance > 0.15:
		joystick_active = true
		
		player.set_aim_input(value)
		player.set_shooting_input(distance > 0.3)

	else:
		# joystick en reposo
		joystick_active = false
		player.set_shooting_input(false)
