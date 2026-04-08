extends CharacterBody2D
class_name PlayerController

@export var move_speed: float = 300.0

var _interaction_sources: Dictionary = {}
var _interaction_source_order: Array[int] = []


func _physics_process(_delta: float) -> void:
	var input_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * move_speed
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_interact"):
		return

	var interaction := _get_primary_interaction()
	if interaction == null:
		return

	interaction.execute()
	get_viewport().set_input_as_handled()


func register_interactions(source: Object, options: Array[InteractionOption]) -> void:
	if source == null:
		return

	var valid_options := _filter_valid_options(options)
	if valid_options.is_empty():
		unregister_interactions(source)
		return

	var source_id := source.get_instance_id()
	_interaction_sources[source_id] = {
		"source": weakref(source),
		"options": valid_options,
	}
	_interaction_source_order.erase(source_id)
	_interaction_source_order.append(source_id)


func unregister_interactions(source: Object) -> void:
	if source == null:
		return

	var source_id := source.get_instance_id()
	_interaction_sources.erase(source_id)
	_interaction_source_order.erase(source_id)


func _filter_valid_options(options: Array[InteractionOption]) -> Array[InteractionOption]:
	var valid_options: Array[InteractionOption] = []
	for option in options:
		if option != null and option.is_available():
			valid_options.append(option)

	valid_options.sort_custom(_sort_interactions)
	return valid_options


func _sort_interactions(left: InteractionOption, right: InteractionOption) -> bool:
	return left.priority > right.priority


func _get_primary_interaction() -> InteractionOption:
	for index in range(_interaction_source_order.size() - 1, -1, -1):
		var source_id := _interaction_source_order[index]
		if not _interaction_sources.has(source_id):
			continue

		var entry: Dictionary = _interaction_sources[source_id]
		var source_ref: WeakRef = entry.get("source")
		if source_ref == null or source_ref.get_ref() == null:
			_interaction_sources.erase(source_id)
			_interaction_source_order.remove_at(index)
			continue

		var options: Array = entry.get("options", [])
		if options.is_empty():
			continue

		var option := options[0] as InteractionOption
		if option != null and option.is_available():
			return option

	return null
