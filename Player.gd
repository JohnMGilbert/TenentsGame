extends CharacterBody2D

var speed = 100
var interacting_with = null
var fireable_interactions = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_interact"):
		if fireable_interactions.size() > 0:
			fireable_interactions[0].call()
	# Handle input for movement
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	# Normalize the direction to avoid faster diagonal movement
	direction = direction.normalized()
	
	# Update the position based on the direction and speed
	position += direction * speed * delta
	
func set_action_options(entity, action_options):
	print("Setting action options for ", entity.name)
	print(action_options)
	fireable_interactions.append_array(action_options)
	
func clear_action_options(entity, actions_to_clear):
	print("Removing actions")
	fireable_interactions = fireable_interactions.filter(func(act): return not act in actions_to_clear)
