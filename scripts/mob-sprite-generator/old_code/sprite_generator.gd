extends RefCounted

const Archetypes = preload("res://scripts/mob-sprite-generator/archetypes.gd")
const SIZE := 32

var rng := RandomNumberGenerator.new()
var grid := []

func set_seed(s: int) -> void:
	rng.seed = s

func generate_raw_grid(iterations: int = 4) -> Array:
	var archetype_id: int = Archetypes.get_archetype_for_seed(rng.seed)
	var zones: Dictionary = Archetypes.get_reserved_zones(archetype_id, SIZE)

	# Empty grid
	grid = []
	for y in range(SIZE):
		var row := []
		for x in range(SIZE):
			row.append(false)
		grid.append(row)

	# Seed core, head, limbs
	for pos in zones.get("core", []):
		if _in_bounds(pos): grid[pos.y][pos.x] = true
	for pos in zones.get("head", []):
		if _in_bounds(pos): grid[pos.y][pos.x] = true
	for pos in zones.get("limb_origins", []):
		if _in_bounds(pos): grid[pos.y][pos.x] = true

	# Debug: count seeded pixels before CA
	var seed_count := 0
	for row in grid:
		for cell in row:
			if cell: seed_count += 1
	print("Seeded pixels before CA:", seed_count)

	# Run CA
	for i in range(iterations):
		grid = _step(grid)

	# Debug: count pixels after CA
	var final_count := 0
	for row in grid:
		for cell in row:
			if cell: final_count += 1
	print("Pixels after CA:", final_count)

	# Fallback: force 1 pixel if still empty
	if final_count == 0:
		print("⚠️ Empty grid — forcing fallback center pixel.")
		grid[SIZE / 2][SIZE / 2] = true

	return grid

func _step(old_grid: Array) -> Array:
	var new_grid := []
	for y in range(SIZE):
		var row := []
		for x in range(SIZE):
			var count := _count_neighbors(old_grid, x, y)
			row.append(count >= 3)
		new_grid.append(row)
	return new_grid

func _count_neighbors(grid: Array, x: int, y: int) -> int:
	var total := 0
	for dy in range(-1, 2):
		for dx in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var nx := x + dx
			var ny := y + dy
			if nx >= 0 and nx < SIZE and ny >= 0 and ny < SIZE:
				if grid[ny][nx]:
					total += 1
	return total

func _in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < SIZE and pos.y >= 0 and pos.y < SIZE
