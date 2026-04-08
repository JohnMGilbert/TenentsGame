extends Camera2D
class_name CameraController

@export var pan_speed: float = 5000.0
@export var zoom_step: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 4.0
@export var lerp_speed: float = 5.0

var target_position := Vector2.ZERO
var is_dragging := false
var last_mouse_position := Vector2.ZERO


func _ready() -> void:
	target_position = position


func _process(delta: float) -> void:
	_update_keyboard_pan(delta)
	position = position.lerp(target_position, lerp_speed * delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_handle_mouse_button(event)
	elif event is InputEventMouseMotion and is_dragging:
		_handle_mouse_drag(event)


func _update_keyboard_pan(delta: float) -> void:
	var input_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_vector == Vector2.ZERO:
		return

	target_position += input_vector * pan_speed * delta


func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		_adjust_zoom(-zoom_step)
		return

	if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
		_adjust_zoom(zoom_step)
		return

	if event.button_index == MOUSE_BUTTON_MIDDLE:
		is_dragging = event.pressed
		last_mouse_position = event.position


func _handle_mouse_drag(event: InputEventMouseMotion) -> void:
	var drag_delta := last_mouse_position - event.position
	target_position += drag_delta / zoom
	last_mouse_position = event.position


func _adjust_zoom(amount: float) -> void:
	var next_zoom := zoom + Vector2(amount, amount)
	next_zoom.x = clamp(next_zoom.x, min_zoom, max_zoom)
	next_zoom.y = clamp(next_zoom.y, min_zoom, max_zoom)
	zoom = next_zoom
