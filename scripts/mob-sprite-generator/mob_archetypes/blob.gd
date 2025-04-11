extends Resource
class_name BlobMobArchetype

func get_part_structure() -> Dictionary:
	return {
		"core": { "position": Vector2(0, 0) },
		"eye": { "position": Vector2(0, -1), "anchor": "core" },
		"pseudopod1": { "position": Vector2(-1, 1), "anchor": "core" },
		"pseudopod2": { "position": Vector2(1, 1), "anchor": "core" }
	}

func get_default_animation_profile() -> String:
	return "blob_squish"
