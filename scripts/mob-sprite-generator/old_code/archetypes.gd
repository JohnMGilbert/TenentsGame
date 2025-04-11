extends RefCounted

enum Archetype {
	BIPED,
	INSECTOID,
	BLOB,
	FLYER,
	EYEBEAST
}

static func get_archetype_for_seed(seed: int) -> int:
	return seed % 5

static func get_archetype_name(id: int) -> String:
	match id:
		Archetype.BIPED: return "Biped"
		Archetype.INSECTOID: return "Insectoid"
		Archetype.BLOB: return "Blob"
		Archetype.FLYER: return "Flyer"
		Archetype.EYEBEAST: return "Eyebeast"
		_: return "Unknown"

static func get_reserved_zones(id: int, size: int) -> Dictionary:
	var mid := size / 2
	var zones := {
		"core": [],
		"head": [],
		"limb_origins": []
	}

	match id:
		Archetype.BIPED:
			zones["core"] = [
				Vector2i(mid, mid),
				Vector2i(mid - 1, mid),
				Vector2i(mid + 1, mid),
				Vector2i(mid, mid + 1),
				Vector2i(mid, mid - 1)
			]
			zones["head"] = [Vector2i(mid, mid - 2)]
			zones["limb_origins"] = [Vector2i(mid - 2, mid + 2), Vector2i(mid + 2, mid + 2)]

		Archetype.INSECTOID:
			zones["core"] = [
				Vector2i(mid, mid),
				Vector2i(mid - 1, mid),
				Vector2i(mid + 1, mid),
				Vector2i(mid, mid + 1)
			]
			zones["limb_origins"] = [
				Vector2i(mid - 3, mid + 1),
				Vector2i(mid + 3, mid + 1),
				Vector2i(mid - 3, mid - 1),
				Vector2i(mid + 3, mid - 1)
			]
			zones["head"] = [Vector2i(mid, mid - 2)]

		Archetype.BLOB:
			var blob_core := []
			for y in range(mid - 1, mid + 2):
				for x in range(mid - 1, mid + 2):
					blob_core.append(Vector2i(x, y))
			zones["core"] = blob_core
			zones["head"] = [Vector2i(mid, mid - 2)]

		Archetype.FLYER:
			zones["core"] = [
				Vector2i(mid, mid),
				Vector2i(mid, mid - 1),
				Vector2i(mid, mid + 1)
			]
			zones["limb_origins"] = [
				Vector2i(mid - 3, mid),
				Vector2i(mid + 3, mid)
			]
			zones["head"] = [Vector2i(mid, mid - 2)]

		Archetype.EYEBEAST:
			zones["core"] = [
				Vector2i(mid, mid),
				Vector2i(mid - 1, mid),
				Vector2i(mid + 1, mid)
			]
			zones["head"] = [
				Vector2i(mid, mid - 1),
				Vector2i(mid - 1, mid - 1),
				Vector2i(mid + 1, mid - 1),
				Vector2i(mid, mid - 2)
			]

	return zones
