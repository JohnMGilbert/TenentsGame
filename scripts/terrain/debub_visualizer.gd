# debug_visualizer.gd
extends Node2D
class_name DebugVisualizer

@export var terrain_map_manager: TerrainMapManager

func _ready():
	queue_redraw()  # Triggers _draw()

func _process(delta):
	# Optional: Auto-refresh debug view
	queue_redraw()

func _draw():
	if terrain_map_manager == null or terrain_map_manager.terrain_map.is_empty():
		return
	
	# Get Camera2D node
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return
	
	# Get camera's visible rectangle in world space
	var cam_pos = camera.position
	var cam_size = get_viewport_rect().size / camera.zoom  # Adjust for zoom
	var cam_rect = Rect2(cam_pos - cam_size * 0.5, cam_size)

	# Tile size for isometric projection
	var tile_width = 64
	var tile_height = 32

	# Estimate which tiles to draw based on screen bounds
	var start_x = max(0, int((cam_rect.position.x / tile_width) - terrain_map_manager.map_width / 2))
	var end_x = min(terrain_map_manager.map_width, int((cam_rect.end.x / tile_width) + terrain_map_manager.map_width / 2))
	var start_y = max(0, int((cam_rect.position.y / tile_height) - terrain_map_manager.map_height / 2))
	var end_y = min(terrain_map_manager.map_height, int((cam_rect.end.y / tile_height) + terrain_map_manager.map_height / 2))

	# Loop **only through visible tiles**
	for x in range(start_x, end_x):
		for y in range(start_y, end_y):
			if x < 0 or x >= terrain_map_manager.map_width or y < 0 or y >= terrain_map_manager.map_height:
				continue

			var cell = terrain_map_manager.terrain_map[x][y]

			# Convert grid coordinates to isometric screen space
			var iso_x = (cell.x - cell.y) * (tile_width / 2)
			var iso_y = (cell.x + cell.y) * (tile_height / 2)

			# Apply height offset to simulate 3D elevation
			var height_offset = -cell.height * tile_height  # Adjust scale if necessary
			var pos = Vector2(iso_x, iso_y + height_offset)

			# Draw diamond (top face)
			var points = [
				pos + Vector2(0, tile_height / 2),
				pos + Vector2(tile_width / 2, 0),
				pos + Vector2(tile_width, tile_height / 2),
				pos + Vector2(tile_width / 2, tile_height)
			]

			var color = Color(cell.height, cell.height, cell.height)  # Grayscale for height
			draw_polygon(points, [color])
