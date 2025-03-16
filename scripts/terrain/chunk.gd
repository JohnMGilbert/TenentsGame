# /scripts/terrain/chunk.gd
extends Node2D
class_name Chunk

@export var chunk_size: int = 16        # 16x16 tiles per chunk
@export var tile_width: int = 64
@export var tile_height: int = 32

# Coordinates in the chunk grid (e.g., chunk 0,0)
var chunk_x: int
var chunk_y: int

# Holds the terrain data for this chunk
var terrain_data: Array = []

# Multimesh and rendering node
var multi_mesh_instance: MultiMeshInstance2D
var multi_mesh: MultiMesh

func _ready():
	generate(0,0)
	
# Create the terrain data (can also load from file later)
func generate(chunk_x_pos: int, chunk_y_pos: int):
	chunk_x = chunk_x_pos
	chunk_y = chunk_y_pos
	
	# Create empty data grid for this chunk
	terrain_data.clear()
	
	for x in range(chunk_size):
		terrain_data.append([])
		for y in range(chunk_size):
			# This is where you'd apply your terrain generation logic!
			# For now, random heights for demo
			var height = randf()  # Placeholder for noise
			var cell = {
				"height": height,
				"biome": null,  # We'll fill this later
				"other_data": null
			}
			terrain_data[x].append(cell)
	
	_build_multimesh()

# Build the multimesh instance for rendering
func _build_multimesh():
	if multi_mesh_instance:
		multi_mesh_instance.queue_free()

	multi_mesh = MultiMesh.new()
	multi_mesh.transform_format = MultiMesh.TRANSFORM_2D
	multi_mesh.instance_count = chunk_size * chunk_size

	multi_mesh_instance = MultiMeshInstance2D.new()
	multi_mesh_instance.multimesh = multi_mesh

	# Add a mesh to render (a simple quad for now)
	var mesh = QuadMesh.new()
	mesh.size = Vector2(tile_width, tile_height)
	multi_mesh_instance.mesh = mesh

	add_child(multi_mesh_instance)

	var instance_idx = 0
	for x in range(chunk_size):
		for y in range(chunk_size):
			var cell = terrain_data[x][y]

			var iso_x = (x - y) * (tile_width / 2)
			var iso_y = (x + y) * (tile_height / 2)
			var height_offset = -cell["height"] * tile_height

			var pos = Vector2(iso_x, iso_y + height_offset)

			var transform = Transform2D(0, pos)
			multi_mesh.set_instance_transform_2d(instance_idx, transform)

			var color_val = cell["height"]
			multi_mesh.set_instance_color(instance_idx, Color(color_val, color_val, color_val))

			instance_idx += 1
