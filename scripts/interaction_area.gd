extends Node2D

var possible_interactions = []
var action = null
var parent
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	possible_interactions = parent.get_possible_actions()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# If interaction area entered by player, display label
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$Label.visible = true
		body.set_action_options(self, possible_interactions)


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$Label.visible = false
		body.clear_action_options(self, possible_interactions)
#
#func _talk_to():
	#
