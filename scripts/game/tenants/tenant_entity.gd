extends Node2D
class_name TenantEntity

@export var tenant_name: String = "Mark Marks"

@onready var _name_label: Label = $Label

var content_level: int = 0
var relationship_power: int = 0
var chance_to_leave: float = 0.0
var profile: TenantProfile

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	if profile == null:
		_rng.randomize()
		profile = TenantProfile.generate(_rng, _resolve_display_name())

	_name_label.text = profile.display_name


func get_interaction_options() -> Array[InteractionOption]:
	return [
		InteractionOption.new(&"talk", "Talk", Callable(self, "_talk_to")),
	]


func set_profile(new_profile: TenantProfile) -> void:
	profile = new_profile
	if is_node_ready():
		_name_label.text = profile.display_name


func _talk_to() -> void:
	print("Hey, you're talking to %s." % profile.display_name)
	print(profile.get_personality_summary())


func _resolve_display_name() -> String:
	if not tenant_name.is_empty():
		return tenant_name
	return name
