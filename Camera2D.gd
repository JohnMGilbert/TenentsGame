extends Camera2D
class_name CameraController

@export var pan_speed: float = 5000.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 4.0
@export var lerp_speed: float = 5.0  # Controls smoothness; higher = faster response

var target_position := Vector2.ZERO
var dragging := false
var last_mouse_pos := Vector2.ZERO

func _ready():
	# Start with camera's initial position as the target
	target_position = position

func _unhandled_input(event):
	# --- WASD or Arrow Key Panning ---
	var move = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		move.x += 1
	if Input.is_action_pressed("ui_left"):
		move.x -= 1
	if Input.is_action_pressed("ui_down"):
		move.y += 1
	if Input.is_action_pressed("ui_up"):
		move.y -= 1
	
	if move != Vector2.ZERO:
		target_position += move.normalized() * pan_speed * get_process_delta_time()

	# --- Mouse Wheel Zooming ---
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom -= Vector2(zoom_speed, zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom += Vector2(zoom_speed, zoom_speed)

		zoom.x = clamp(zoom.x, min_zoom, max_zoom)
		zoom.y = clamp(zoom.y, min_zoom, max_zoom)

	# --- Middle Mouse Drag Panning ---
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				dragging = true
				last_mouse_pos = event.position
			else:
				dragging = false

	if event is InputEventMouseMotion and dragging:
		var delta = last_mouse_pos - event.position
		target_position += delta / zoom  # Zoom compensated drag
		last_mouse_pos = event.position

func _process(delta):
	# Interpolate towards target position
	position = position.lerp(target_position, lerp_speed * delta)
