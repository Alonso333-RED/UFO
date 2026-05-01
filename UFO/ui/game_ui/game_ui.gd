extends Control

@onready var player = $"../Player"
@onready var aim_joystick = $"CanvasLayer/shoot_container/VirtualJoystickPlus"
@onready var move_joystick = $"CanvasLayer/movement_container/VirtualJoystickPlus"

var use_joystick_on_pc := true

var move_active := false
var aim_active := false

var aim_using_joystick := false

func _ready():
	aim_joystick.analogic_changed.connect(_on_aim_changed)
	move_joystick.analogic_changed.connect(_on_move_changed)

# -------------------------
# MOVIMIENTO
# -------------------------
@warning_ignore("unused_parameter")
func _on_move_changed(value, distance, angle, angle_clockwise, angle_counter):
	if not OS.has_feature("mobile") and not use_joystick_on_pc:
		return

	if distance > 0.15:
		move_active = true
		player.set_move_input(value)
	else:
		move_active = false
		player.set_move_input(Vector2.ZERO)


# -------------------------
# AIM + SHOOT
# -------------------------
@warning_ignore("unused_parameter")
func _on_aim_changed(value, distance, angle, angle_clockwise, angle_counter):

	if not OS.has_feature("mobile") and not use_joystick_on_pc:
		return

	if distance > 0.15:
		aim_active = true
		aim_using_joystick = true

		player.set_aim_input(value)
		player.set_shooting_input(distance > 0.3)
	else:
		aim_active = false
		aim_using_joystick = false
		player.set_shooting_input(false)
