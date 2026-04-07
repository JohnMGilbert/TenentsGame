extends Node2D
class_name HeadComponent

@export var bob_enabled: bool = true
@export var offset: Vector2 = Vector2.ZERO

var original_position: Vector2
var bob_time := 0.0 

func _ready():
	original_position = position

func _process(delta):
	if bob_enabled:
		bob_time += delta
		position.y = original_position.y + sin(bob_time * 4.0) * 1.5
