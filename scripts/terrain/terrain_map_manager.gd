# terrain_map_manager.gd
extends Node2D
class_name TerrainMapManager

@export var map_width: int = 50
@export var map_height: int = 50
@export var block_size: int = 16  # How big the blocks are (visual size)

var terrain_map: Array = []

func _ready():
	generate_empty_map()

func generate_empty_map():
	terrain_map.clear()

	for x in range(map_width):
		terrain_map.append([])  # Create row
		for y in range(map_height):
			var cell = TerrainCell.new(x, y)
			terrain_map[x].append(cell)

	print("Terrain map created: %sx%s cells" % [map_width, map_height])
