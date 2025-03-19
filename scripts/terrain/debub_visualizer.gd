extends MultiMeshInstance2D
class_name DebugVisualizer

@export var terrain_map_manager: TerrainMapManager
@export var tile_width: int = 64
@export var tile_height: int = 32

func generate_debug_multimesh():
	if terrain_map_manager == null or terrain_map_manager.terrain_map.is_empty():
		push_warning("No TerrainMapManager or terrain map is empty.")
		return

	var width = terrain_map_manager.map_width
	var height = terrain_map_manager.map_height

	# ✅ Create MultiMesh and enable colors
	var multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_2D
	multimesh.use_colors = true  # ✅ This line fixes the error!
	multimesh.instance_count = width * height

	# ✅ Shader to display instance colors
	var shader = Shader.new()
	shader.code = """
	shader_type canvas_item;
	render_mode unshaded;

	void fragment() {
		COLOR = INSTANCE_CUSTOM.rgb;
	}
	"""

	var material = ShaderMaterial.new()
	material.shader = shader

	# ✅ Assign mesh with material
	var mesh = create_diamond_mesh()
	mesh.surface_set_material(0, material)


	multimesh.mesh = mesh
	self.multimesh = multimesh

	var idx = 0
	for x in range(width):
		for y in range(height):
			var cell = terrain_map_manager.terrain_map[x][y]

			var iso_x = (cell.x - cell.y) * (tile_width / 2)
			var iso_y = (cell.x + cell.y) * (tile_height / 2 ) # divide by 2 * X where x < 1 for effects

			var height_offset = -cell.height * tile_height
			var pos = Vector2(iso_x, iso_y + height_offset)

			var transform = Transform2D(0, pos)
			transform.x *= tile_width
			transform.y *= tile_height

			multimesh.set_instance_transform_2d(idx, transform)

			var color = Color(cell.height, cell.height, cell.height)
			multimesh.set_instance_color(idx, color)

			idx += 1


			
func create_diamond_mesh() -> ArrayMesh:
	var mesh = ArrayMesh.new()
	var arrays = []
	
	var vertices = PackedVector3Array([
		Vector3(0, -0.5, 0),   # Top
		Vector3(0.5, 0, 0),    # Right
		Vector3(0, 0.5, 0),    # Bottom
		Vector3(-0.5, 0, 0)    # Left
	])

	
	var indices = PackedInt32Array([
		0, 1, 2,
		0, 2, 3
	])

	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh

