extends Node2D
class_name InteractionArea

@export var interactions_source_path: NodePath
@export var prompt_text: String = ""

@onready var _label: Label = $Label

var _interactions_source: Node


func _ready() -> void:
	_interactions_source = _resolve_interactions_source()
	if _interactions_source == null:
		push_warning("Interaction source could not be resolved for %s." % get_path())
	elif not _interactions_source.has_method("get_interaction_options"):
		push_warning("%s must implement get_interaction_options()." % _interactions_source.get_path())

	_label.visible = false
	_label.text = _build_prompt_text(_get_interaction_options())


func _on_area_2d_body_entered(body: Node) -> void:
	if not body.has_method("register_interactions"):
		return

	var options := _get_interaction_options()
	if options.is_empty():
		return

	_label.text = _build_prompt_text(options)
	_label.visible = true
	body.call("register_interactions", self, options)


func _on_area_2d_body_exited(body: Node) -> void:
	if not body.has_method("unregister_interactions"):
		return

	_label.visible = false
	body.call("unregister_interactions", self)


func _resolve_interactions_source() -> Node:
	if interactions_source_path.is_empty():
		return get_parent()

	return get_node_or_null(interactions_source_path)


func _get_interaction_options() -> Array[InteractionOption]:
	var options: Array[InteractionOption] = []
	if _interactions_source == null or not _interactions_source.has_method("get_interaction_options"):
		return options

	var raw_options: Array = _interactions_source.call("get_interaction_options")
	for raw_option in raw_options:
		var option := raw_option as InteractionOption
		if option != null and option.is_available():
			options.append(option)

	return options


func _build_prompt_text(options: Array[InteractionOption]) -> String:
	if not prompt_text.is_empty():
		return prompt_text
	if not options.is_empty():
		return "%s [E]" % options[0].label
	return "Interact [E]"
