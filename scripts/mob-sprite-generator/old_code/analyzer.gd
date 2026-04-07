extends RefCounted
class_name SpriteAnalyzer

var _grid: Array = []
var _labels: Array = []
var _visited: Array = []
var _width: int
var _height: int

func label_components(grid: Array) -> Dictionary:
	_grid = grid
	_width = grid.size()
	_height = grid[0].size() if _width > 0 else 0
	_labels = []
	_visited = []

	var next_label := 1

	for y in range(_height):
		_labels.append([])
		_visited.append([])
		for x in range(_width):
			_labels[y].append(0)
			_visited[y].append(false)

	for y in range(_height):
		for x in range(_width):
			if _grid[y][x] and not _visited[y][x]:
				_flood_fill(x, y, next_label)
				next_label += 1

	return {
		"label_map": _labels,
		"count": next_label - 1
	}

func _flood_fill(x: int, y: int, label: int) -> void:
	var stack: Array[Vector2i] = [Vector2i(x, y)]
	while not stack.is_empty():
		var p: Vector2i = stack.pop_back()
		if p.x < 0 or p.x >= _width or p.y < 0 or p.y >= _height:
			continue
		if _visited[p.y][p.x] or not _grid[p.y][p.x]:
			continue
		_visited[p.y][p.x] = true
		_labels[p.y][p.x] = label

		for dy in range(-1, 2):
			for dx in range(-1, 2):
				if dx == 0 and dy == 0:
					continue
				stack.append(Vector2i(p.x + dx, p.y + dy))

func classify_parts(grid: Array) -> Dictionary:
	var result := label_components(grid)
	var label_map: Array = result["label_map"]
	var label_count: int = result["count"]

	var parts := {}  # label_id -> [Vector2i...]
	var roles := {}  # "body", "head", "limb1", ...

	# Group all pixels by label
	for y in range(label_map.size()):
		for x in range(label_map[0].size()):
			var label: int = label_map[y][x]
			if label == 0:
				continue
			if not parts.has(label):
				parts[label] = []
			parts[label].append(Vector2i(x, y))

	# Step 1: find the largest component → "body"
	var largest_label := -1
	var largest_size := 0
	for label in parts.keys():
		var size: int = parts[label].size()
		if size > largest_size:
			largest_size = size
			largest_label = label
	roles["body"] = parts[largest_label]

	# Step 2: find topmost (lowest Y avg) → "head"
	var topmost_label := -1
	var topmost_y := 9999
	for label in parts.keys():
		if label == largest_label:
			continue
		var pixels: Array = parts[label]
		var sum_y: int = 0
		for p in pixels:
			sum_y += p.y
		var avg_y: float = float(sum_y) / float(pixels.size())
		if avg_y < topmost_y:
			topmost_y = avg_y
			topmost_label = label
	if topmost_label != -1:
		roles["head"] = parts[topmost_label]

	# Step 3: label remaining as limbs
	var limb_index := 1
	for label in parts.keys():
		if label == largest_label or label == topmost_label:
			continue
		roles["limb%d" % limb_index] = parts[label]
		limb_index += 1

	return roles  # keys: body, head, limb1, limb2, ...
