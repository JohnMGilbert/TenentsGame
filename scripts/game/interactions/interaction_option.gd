extends RefCounted
class_name InteractionOption

var id: StringName
var label: String
var callback: Callable
var priority: int


func _init(_id: StringName, _label: String, _callback: Callable, _priority: int = 0) -> void:
	id = _id
	label = _label
	callback = _callback
	priority = _priority


func is_available() -> bool:
	return callback.is_valid()


func execute() -> void:
	if callback.is_valid():
		callback.call()
