extends RefCounted

var initial_density = 0.4

const SIZE := 32 
var rng := RandomNumberGenerator.new()
var grid := []

func set_seed(s: int) -> void:
	rng.seed = s

func generate() -> Image:
	_init_grid()
	for i in range(4):
		grid = _step(grid)
	return _to_image(grid)

func _init_grid() -> void:
	grid = []
	var half_size := int(SIZE / 2)
	for y in range(SIZE):
		var row := []
		for x in range(half_size):
			row.append(rng.randf() < initial_density)
		var mirrored := row.duplicate()
		mirrored.reverse()
		row += mirrored
		grid.append(row)
	#_apply_random_walks(1, 6)  # add 4 random walks, each 12 steps long

func _step(old_grid: Array) -> Array:
	var new_grid := []
	for y in range(SIZE):
		var row := []
		for x in range(SIZE):
			var count := _count_neighbors(old_grid, x, y)
			row.append(count >= 4)
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

func _to_image(grid: Array) -> Image:
	var image := Image.create(SIZE, SIZE, false, Image.FORMAT_RGBA8)
	for y in range(SIZE):
		for x in range(SIZE):
			var c := Color.BLACK if grid[y][x] else Color(0, 0, 0, 0)
			image.set_pixel(x, y, c)
	return image

func generate_raw_grid() -> Array:
	_init_grid()
	#_apply_random_walks(4, 12)  # add 4 random walks, each 12 steps long
	for i in range(4):
		grid = _step(grid)
	return grid
	
func pad_grid(grid: Array) -> Array:
	var new_size: int = grid.size() + 2
	var padded: Array = []

	for y in range(new_size):
		var row: Array = []
		for x in range(new_size):
			# Copy old grid into center, else fill with false
			if y > 0 and y < new_size - 1 and x > 0 and x < new_size - 1:
				row.append(grid[y - 1][x - 1])
			else:
				row.append(false)
		padded.append(row)

	return padded


func _apply_random_walks(walk_count: int = 3, length: int = 10) -> void:
	var center := Vector2i(SIZE / 2, SIZE / 2)
	
	for i in range(walk_count):
		var pos := center
		for j in range(length):
			if pos.x >= 0 and pos.x < SIZE and pos.y >= 0 and pos.y < SIZE:
				grid[pos.y][pos.x] = true
			
			# Choose a random direction: up, down, left, right
			var dir := Vector2i(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
			while dir == Vector2i.ZERO:
				dir = Vector2i(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
			
			pos += dir
