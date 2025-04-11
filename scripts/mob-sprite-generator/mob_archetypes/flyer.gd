extends Resource
class_name FlyerMobArchetype

func get_part_structure() -> Dictionary:
	return {
		"body": { "position": Vector2(0, 0) },
		"head": { "position": Vector2(0, -1), "anchor": "body" },
		"wing_left": { "position": Vector2(-2, 0), "anchor": "body" },
		"wing_right": { "position": Vector2(2, 0), "anchor": "body" },
		"tail": { "position": Vector2(0, 2), "anchor": "body" }
	}

func get_default_animation_profile() -> String:
	return "flyer_float"
