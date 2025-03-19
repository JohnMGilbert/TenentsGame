extends Control
class_name CachedTerrainDrawer

@export var terrain_map_manager: TerrainMapManager
@export var tile_width: int = 64
@export var tile_height: int = 32

func _ready():
	queue_redraw()  # Draw once at startup

func _draw():
	if terrain_map_manager == null or terrain_map_manager.terrain_map.is_empty():
		return

	for x in range(terrain_map_manager.map_width):
		for y in range(terrain_map_manager.map_height):
			var cell = terrain_map_manager.terrain_map[x][y]

			# Isometric conversion
			var iso_x = (cell.x - cell.y) * (tile_width / 2)
			var iso_y = (cell.x + cell.y) * (tile_height / 2)

			# Apply height offset
			var height_offset = -cell.height * tile_height
			var pos = Vector2(iso_x, iso_y + height_offset)

			var points = [
				pos + Vector2(0, tile_height / 2),
				pos + Vector2(tile_width / 2, 0),
				pos + Vector2(tile_width, tile_height / 2),
				pos + Vector2(tile_width / 2, tile_height)
			]

			var color = Color(cell.height, cell.height, cell.height)
			draw_polygon(points, [color])
