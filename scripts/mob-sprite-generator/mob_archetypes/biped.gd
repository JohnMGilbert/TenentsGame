extends Resource
class_name BipedMobArchetype

# Parts list this archetype expects
func get_part_structure() -> Dictionary:
	return {
		"body": { "position": Vector2(0, 0) },
		"head": { "position": Vector2(0, -1), "anchor": "body" },
		"limb1": { "position": Vector2(-1, 1), "anchor": "body" },
		"limb2": { "position": Vector2(1, 1), "anchor": "body" }
	}

# Optional: return pose override logic
func get_default_animation_profile() -> String:
	return "biped_walk"
