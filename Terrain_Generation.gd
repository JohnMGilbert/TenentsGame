extends TileMap

var noise := FastNoiseLite.new()
const NUM_LAYERS = 8
var map_matrix = []
var map_height = 300
var map_width = 300

var layers_enabled = NUM_LAYERS - 1

var atlas_coordinates = {
	"1111" : Vector2i(2,1),
	"1110" : Vector2i(2,1),
	"1101" : Vector2i(2,1),
	"0100" : Vector2i(2,1),
	"1011" : Vector2i(1,1),
	"1010" : Vector2i(1,1),
	"0111" : Vector2i(0,1),
	"0011" : Vector2i(0,0),
	"0101" : Vector2i(0,1),
	"0000" : Vector2i(0,0),
	"1100" : Vector2i(0,0),
	
}

func _ready():
	for l in range(NUM_LAYERS-1):
		add_layer(l)
		set_layer_y_sort_enabled(l,true)
		set_layer_z_index(l,l)
		set_layer_y_sort_origin(l,l)
	

	# Configure the noise properties
	
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()  # Randomize seed
	noise.frequency = 0.03
	noise.domain_warp_amplitude = 0.005
	noise.fractal_gain = 0.05
	noise.fractal_lacunarity = 2.0
	noise.fractal_octaves = 2     # Number of levels of detail
	noise.fractal_weighted_strength = 0.0
	#noise.period = 20.0    # The distance between peaks in the noise
	#noise.persistence = 0.5  # How much detail decreases at each octave

	# Generate the terrain using Perlin noise
	generate_terrain(map_height, map_width, 1)  # Width, height, and scale
	get_atlas_coords_matrix(map_height,map_width,map_matrix)
# Generates a matrix with values representing what layer the terrain block is on
func generate_terrain(width, height, scaler):
	# Loop through each point on the grid
	for y in range(height):
		var row = []
		for x in range(width):
			# Get Perlin noise value at this point, scaled
			var nx = x / scaler
			var ny = y / scaler
			var noise_value = noise.get_noise_2d(nx, ny) # Between -1, 1
			var normalized_value = (noise_value + 1.0) / 2.0
			var layer = int(normalized_value * NUM_LAYERS)
			print(layer)
			#layer = clamp(layer, 0, NUM_LAYERS - 1)
			row.append(layer)
			#set_cell(abs(layer-NUM_LAYERS-1), Vector2i(x-layer,y-layer),0,Vector2i(2,1))
		map_matrix.append(row)


func get_atlas_coords_matrix(width, height, map_values):
	for y in range(height):
		for x in range(width):
			var neighbors = get_neighbors(map_values,x,y)
			var atlas_val = get_atlas_val_from_neighbors(neighbors)
			var layer = map_values[x][y]
			if atlas_coordinates.has(atlas_val):
				set_cell(map_values[x][y],Vector2i(x-layer,y-layer),0,atlas_coordinates[atlas_val])
				var down_layer = layer
				while (down_layer >= 0):
					set_cell(down_layer,Vector2i(x-down_layer,y-down_layer),0,Vector2i(2,1))
					down_layer -= 1
					
			else:
				set_cell(map_values[x][y],Vector2i(x-layer,y-layer),0,Vector2i(2,1))
				var down_layer = layer
				while (down_layer >= 0):
					set_cell(down_layer,Vector2i(x-down_layer,y-down_layer),0,Vector2i(2,1))
					down_layer -= 1

# Function to get a 3x3 matrix of neighbors with the center block
func get_neighbors(matrix, x, y):
	# Initialize a 3x3 matrix filled with a default value (e.g., -1 for empty)
	var neighbor_matrix = []
	
	for i in range(3):
		var row = []
		for j in range(3):
			row.append(-1)  # Use -1 to represent an invalid or out-of-bounds area
		neighbor_matrix.append(row)

	# Iterate through the neighboring coordinates
	for dy in range(-1, 2):
		for dx in range(-1, 2):
			var nx = x + dx
			var ny = y + dy
			
			# Ensure we don't go out of bounds of the original matrix
			if nx >= 0 and nx < matrix.size() and ny >= 0 and ny < matrix[0].size():
				neighbor_matrix[dy + 1][dx + 1] = matrix[nx][ny]
	return neighbor_matrix
	
# Optimized to testing, not full implementation
# Currently gets atlas coords based on bit values, but eventually we will need more detail
# EG does not aaccount for cells a layer above, or neighbor y distance from current cell.
func get_atlas_val_from_neighbors(current_cell_mat):
	var normalized_neighborhood = []
	var current = current_cell_mat[1][1]  # Center value
	var res = ""
	# Only consider the four cardinal directions: above, below, left, right
	for i in range(3):
		for j in range(3):
			if (i == 1 and j == 1):  # Skip the center
				continue
			
			# Only consider neighbors directly above, below, left, and right
			if (i == 0 and j == 1) or (i == 1 and j == 0) or (i == 1 and j == 2) or (i == 2 and j == 1):
				if current_cell_mat[i][j] >= current:
					normalized_neighborhood.append(1)
					res += str(1)
				else:
					normalized_neighborhood.append(0)
					res += str(0)

	# Match logic can be added here if needed
	# Example:
	return res  # Or the atlas value

func _process(delta):
	if Input.is_action_just_pressed("ui_layer_down"):
		self.set_layer_enabled(layers_enabled,false)
		layers_enabled -= 1
	if Input.is_action_just_pressed("ui_layer_up"):
		set_layer_enabled(layers_enabled + 1,true)
		layers_enabled += 1
