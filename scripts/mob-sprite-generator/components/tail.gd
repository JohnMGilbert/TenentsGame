extends Node2D
class_name TailComponent

@export var swing_enabled: bool = true
@export var swing_range: Vector2 = Vector2(-5, 5)
@export var swing_speed: float = 2.0
@export var phase_offset: float = 0.5  # Desync from other parts

var base_rotation := 0.0
var swing_phase := 0.0

func _ready():
	base_rotation = rotation_degrees

func _process(delta):
	if swing_enabled:
		swing_phase += delta * swing_speed
		rotation_degrees = base_rotation + sin(swing_phase + phase_offset) * ((swing_range.y - swing_range.x) / 2.0)
