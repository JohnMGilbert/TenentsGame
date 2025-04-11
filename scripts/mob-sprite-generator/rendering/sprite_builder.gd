extends Node
class_name SpriteBuilder

const SIZE := 32

var rng := RandomNumberGenerator.new()

func generate_grid(seed: int, structure: Dictionary) -> Array:
	rng.seed = seed

	var grid := _init_grid()
	_seed_core(grid, structure)
	_seed_limbs(grid, structure)

	# Run cellular automata
	for i in range(4):
		grid = _step_ca(grid)
		
	var count := 0
	for row in grid:
		for cell in row:
			if cell:
				count += 1
	print("Active pixels after CA:", count)


	return grid


func _init_grid() -> Array:
	var grid := []
	for y in range(SIZE):
		var row := []
		for x in range(SIZE):
			row.append(false)
		grid.append(row)
	return grid


func _seed_core(grid: Array, structure: Dictionary) -> void:
	for part in structure.keys():
		if part == "core" or part == "body":
			var pos: Vector2 = structure[part].get("position", Vector2.ZERO)
			var grid_pos: Vector2 = pos + Vector2(SIZE / 2, SIZE / 2)
			_set_pixel(grid, grid_pos, true)


func _seed_limbs(grid: Array, structure: Dictionary) -> void:
	for part in structure.keys():
		if part.begins_with("limb") or part.begins_with("wing") or part == "tail":
			var origin: Vector2 = structure[part].get("position", Vector2.ZERO) + Vector2(SIZE / 2, SIZE / 2)
			var pos: Vector2 = origin
			for i in range(6):  # random walk length
				_set_pixel(grid, pos, true)
				var dir: Vector2 = Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
				while dir == Vector2.ZERO:
					dir = Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
				pos += dir
				pos = pos.clamp(Vector2(0, 0), Vector2(SIZE - 1, SIZE - 1))


func _set_pixel(grid: Array, pos: Vector2, value: bool) -> void:
	var x: int = int(pos.x)
	var y: int = int(pos.y)
	if x >= 0 and x < SIZE and y >= 0 and y < SIZE:
		grid[y][x] = value


func _step_ca(grid: Array) -> Array:
	var new_grid := _init_grid()
	for y in range(SIZE):
		for x in range(SIZE):
			var neighbors := _count_neighbors(grid, x, y)
			new_grid[y][x] = neighbors >= 3
	return new_grid


func _count_neighbors(grid: Array, x: int, y: int) -> int:
	var total := 0
	for dy in range(-1, 2):
		for dx in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var nx: int = x + dx
			var ny: int = y + dy
			if nx >= 0 and nx < SIZE and ny >= 0 and ny < SIZE:
				if grid[ny][nx]:
					total += 1
	return total


func render_grid(grid: Array, fill_color: Color = Color.WHITE) -> Image:
	var image: Image = Image.create(SIZE, SIZE, false, Image.FORMAT_RGBA8)
	for y in range(SIZE):
		for x in range(SIZE):
			var color := fill_color if grid[y][x] else Color(0, 0, 0, 0)
			image.set_pixel(x, y, color)
	return image
