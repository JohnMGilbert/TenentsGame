extends TextureRect
class_name TerrainMapView

@export var terrain_map_manager: TerrainMapManager
@export var tile_size: int = 2  # 1 or 2 pixel tiles for lightweight rendering

var map_image: Image
var map_texture: ImageTexture

func _ready():
	map_image = Image.create(1, 1, false, Image.FORMAT_RGB8)
	map_texture = ImageTexture.create_from_image(map_image)
	texture = map_texture

func update_terrain_map_view():
	if terrain_map_manager == null:
		push_warning("No TerrainMapManager assigned!")
		return
	
	var width = terrain_map_manager.map_width
	var height = terrain_map_manager.map_height

	# Create the image to match the terrain map
	map_image = Image.create(width, height, false, Image.FORMAT_RGB8)
	
	# Lock the image for direct pixel editing
	map_image.lock()

	# Fill in terrain colors based on height
	for x in range(width):
		for y in range(height):
			var cell = terrain_map_manager.terrain_map[x][y]
			
			var height_value = cell.height  # Assumes height normalized 0.0 - 1.0

			# Color grayscale by height (or use colors for biomes later)
			var color = Color(height_value, height_value, height_value)
			
			map_image.set_pixel(x, y, color)

	map_image.unlock()

	# Update texture and apply it
	map_texture = ImageTexture.create_from_image(map_image)
	texture = map_texture
	
	# Resize the TextureRect based on tile size (for scaling)
	custom_minimum_size = Vector2(width, height) * tile_size
	stretch_mode = STRETCH_SCALE
