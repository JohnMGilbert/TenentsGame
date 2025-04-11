extends Node2D
class_name LimbComponent

@export var swing_enabled: bool = false
@export var thrust_enabled: bool = false
@export var swing_range: Vector2 = Vector2(-15, 15)  # Degrees
@export var swing_speed: float = 4.0

var original_rotation: float
var swing_phase := 0.0

func _ready():
	original_rotation = rotation_degrees

func _process(delta):
	if swing_enabled:
		swing_phase += delta * swing_speed
		rotation_degrees = original_rotation + sin(swing_phase) * (swing_range.y - swing_range.x) / 2.0

	elif thrust_enabled:
		# Optional: add a thrust animation logic if needed
		pass
