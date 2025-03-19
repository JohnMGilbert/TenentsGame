extends Node
class_name HeightMapGenerator

@export var terrain_map_manager: TerrainMapManager

# Noise settings
@export var seed: int = 1337
@export var frequency: float = 0.05
@export var noise_type: FastNoiseLite.NoiseType = FastNoiseLite.TYPE_SIMPLEX
@export var octaves: int = 4
@export var lacunarity: float = 2.0
@export var gain: float = 0.5
@export var ground_level_threshold: float = 0.1


var noise := FastNoiseLite.new()

func _ready():
	# Optional: auto-generate on scene load
	generate_height_map()
	$"../DebugVisualizer".generate_debug_multimesh()


func generate_height_map():
	if terrain_map_manager == null:
		push_warning("No TerrainMapManager assigned!")
		return

	# Configure noise
	noise.seed = seed
	noise.noise_type = noise_type
	noise.frequency = frequency
	noise.fractal_octaves = octaves
	noise.fractal_lacunarity = lacunarity
	noise.fractal_gain = gain

	# Loop through the terrain map and assign heights
	for x in range(terrain_map_manager.map_width):
		for y in range(terrain_map_manager.map_height):
			var nx = float(x) / terrain_map_manager.map_width
			var ny = float(y) / terrain_map_manager.map_height

			# Get raw noise (-1 to 1)
			var value = noise.get_noise_2d(x, y)

			# Normalize to 0.0 - 1.0
			value = (value + 1.0) * 0.5


			if value < 0.3:
				value = 0.0  # Flat ground level
			elif value < 0.6:
				value = 0.5  # Gentle hills
			else:
				value = 1.0  # High cliffs/mountains


			var cell = terrain_map_manager.terrain_map[x][y]
			cell.height = value
			


	print("Height map generated!")
	post_process_connectivity()
	$"../DebugVisualizer".generate_debug_multimesh()
	
func flood_fill(start_pos: Vector2i) -> Array:
	var connected_tiles: Array = []
	var visited := {}
	var queue := []
	
	queue.append(start_pos)
	visited[start_pos] = true
	
	while queue.size() > 0:
		var current = queue.pop_front()
		connected_tiles.append(current)

		# Explore 4 cardinal neighbors
		var neighbors = [
			Vector2i(current.x + 1, current.y),
			Vector2i(current.x - 1, current.y),
			Vector2i(current.x, current.y + 1),
			Vector2i(current.x, current.y - 1)
		]

		for neighbor in neighbors:
			if neighbor.x < 0 or neighbor.x >= terrain_map_manager.map_width:
				continue
			if neighbor.y < 0 or neighbor.y >= terrain_map_manager.map_height:
				continue

			if visited.has(neighbor):
				continue

			# Only visit tiles at height 0
			var cell = terrain_map_manager.terrain_map[neighbor.x][neighbor.y]
			if cell.height <= ground_level_threshold:
				queue.append(neighbor)
				visited[neighbor] = true
	
	return connected_tiles
	
func post_process_connectivity():
	# Step 1: Pick a start point
	var start_x = terrain_map_manager.map_width / 2
	var start_y = terrain_map_manager.map_height / 2
	
	var start_cell = terrain_map_manager.terrain_map[start_x][start_y]

	# If the start point isn't on ground level, find one
	if start_cell.height != 0.0:
		var found = false
		for x in range(terrain_map_manager.map_width):
			for y in range(terrain_map_manager.map_height):
				var cell = terrain_map_manager.terrain_map[x][y]
				if cell.height <= ground_level_threshold:
					start_x = x
					start_y = y
					found = true
					break
			if found:
				break
		
		if not found:
			print("No ground-level tiles found!")
			return
	
	# Step 2: Run flood fill from starting position
	var connected_tiles = flood_fill(Vector2i(start_x, start_y))
	print("Connected ground tiles:", connected_tiles.size())

	# (Optional) Step 3: Highlight disconnected tiles or carve connections


