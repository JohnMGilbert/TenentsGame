extends RefCounted

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func set_seed(seed: int) -> void:
	rng.seed = seed

func get_palette() -> Dictionary:
	var hue: int = rng.randi_range(0, 359)
	
	var body_color: Color = Color.from_hsv(hue / 360.0, 0.6, 0.8)
	var accent_color: Color = Color.from_hsv(((hue + 180) % 360) / 360.0, 0.6, 0.9)
	var highlight_color: Color = Color.from_hsv(((hue + 30) % 360) / 360.0, 0.4, 1.0)

	return {
		"body": body_color,
		"accent": accent_color,
		"highlight": highlight_color
	}

func apply_palette(grid: Array, palette: Dictionary) -> Image:
	var size: int = grid.size()
	var image: Image = Image.create(size, size, false, Image.FORMAT_RGBA8)

	for y in range(size):
		for x in range(size):
			var pixel_on: bool = grid[y][x]
			if pixel_on:
				var neighbor_count: int = _count_neighbors(grid, x, y)
				var color: Color

				if neighbor_count <= 3:
					color = palette["highlight"]
				elif neighbor_count <= 5:
					color = palette["accent"]
				else:
					color = palette["body"]

				image.set_pixel(x, y, color)
			else:
				image.set_pixel(x, y, Color(0, 0, 0, 0))  # transparent

	return image


func _count_neighbors(grid: Array, x: int, y: int) -> int:
	var count: int = 0
	for dy in range(-1, 2):
		for dx in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var nx := x + dx
			var ny := y + dy
			if nx >= 0 and nx < grid.size() and ny >= 0 and ny < grid.size():
				if grid[ny][nx]:
					count += 1
	return count



func add_outline(image: Image) -> Image:
	var size: Vector2i = image.get_size()
	var outlined_image: Image = image.duplicate()
	
	for y in range(size.y):
		for x in range(size.x):
			if image.get_pixel(x, y).a == 0.0:
				var has_filled_neighbor: bool = false
				for dy in range(-1, 2):
					for dx in range(-1, 2):
						if dx == 0 and dy == 0:
							continue
						var nx: int = x + dx
						var ny: int = y + dy
						if nx >= 0 and nx < size.x and ny >= 0 and ny < size.y:
							if image.get_pixel(nx, ny).a > 0.0:
								has_filled_neighbor = true
				if has_filled_neighbor:
					outlined_image.set_pixel(x, y, Color.BLACK)
	return outlined_image
	
	
func debug_render_parts(part_map: Dictionary, size: int) -> Image:
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
	var color_list := [
		Color.DARK_GREEN,  # body
		Color.LIGHT_BLUE,  # head
		Color.YELLOW,
		Color.RED,
		Color.ORANGE,
		Color.MAGENTA,
		Color.CYAN
	]

	var index := 0
	for key in part_map.keys():
		var color: Color = color_list[index % color_list.size()]
		for pos in part_map[key]:
			image.set_pixel(pos.x, pos.y, color)
		index += 1

	return image

