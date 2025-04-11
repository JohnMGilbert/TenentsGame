extends Node2D
class_name MobAssembler

@export var archetype: Resource
@export var part_scenes := {
	"head": preload("res://scripts/mob-sprite-generator/components/head.gd"),
	"limb": preload("res://scripts/mob-sprite-generator/components/limb.gd"),
	"tail": preload("res://scripts/mob-sprite-generator/components/tail.gd")
}

var parts := {}  # Stores each spawned part node by name

func _ready():
	if archetype == null:
		print("⚠️ No archetype assigned!")
		return

	_build_parts_from_archetype(archetype)

func _build_parts_from_archetype(arch: Resource) -> void:
	var structure = arch.get_part_structure()

	for part_name in structure.keys():
		var info = structure[part_name]
		var type = _get_part_type(part_name)

		if not part_scenes.has(type):
			print("⚠️ Unknown part type:", type)
			continue

		var part_scene = part_scenes[type]
		var node = part_scene.new()
		node.name = part_name

		node.position = info.get("position", Vector2.ZERO)
		add_child(node)

		# If anchored, parent to another part
		if info.has("anchor") and parts.has(info["anchor"]):
			parts[info["anchor"]].add_child(node)
			node.position = info["position"]

		parts[part_name] = node

func _get_part_type(name: String) -> String:
	# Simple rule: part names start with part type name
	if name.begins_with("limb"):
		return "limb"
	elif name.begins_with("wing"):
		return "limb"  # or separate if you have wing.gd
	elif name.begins_with("tail"):
		return "tail"
	elif name == "head":
		return "head"
	elif name == "core" or name == "body":
		return "head"  # fallback behavior
	else:
		return "limb"  # default fallback
