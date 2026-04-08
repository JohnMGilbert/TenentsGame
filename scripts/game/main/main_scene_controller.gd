extends Node2D
class_name MainSceneController

@export var start_in_fullscreen: bool = true


func _ready() -> void:
	if start_in_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
