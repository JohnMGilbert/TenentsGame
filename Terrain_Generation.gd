extends TileMap

var noise := FastNoiseLite.new()
const NUM_LAYERS = 20

func _ready():
	for l in range(NUM_LAYERS):
		add_layer(l)
		set_layer_y_sort_enabled(l,true)
		set_layer_z_index(l,l)
		set_layer_y_sort_origin(l,l)
	

	# Configure the noise properties
	
	#noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = randi()  # Randomize seed
	noise.frequency = randf()
	#noise.octaves = 4      # Number of levels of detail
	#noise.period = 20.0    # The distance between peaks in the noise
	#noise.persistence = 0.5  # How much detail decreases at each octave

	# Generate the terrain using Perlin noise
	generate_terrain(100, 100, 1)  # Width, height, and scale

func generate_terrain(width, height, scale):
	# Loop through each point on the grid
	
	for y in range(height):
		for x in range(width):
			# Get Perlin noise value at this point, scaled
			var nx = x / scale
			var ny = y / scale
			var noise_value = noise.get_noise_2d(nx, ny)
			
			var normalized_value = (noise_value + 1.0) / 2.0
			var layer = int(normalized_value * NUM_LAYERS)
			layer = clamp(layer, 0, NUM_LAYERS - 1)
			set_cell(layer, Vector2i(x,y),0,Vector2i(0,0))
			# Map noise_value to tile type
			#if noise_value < -0.2:
				#print("l0")
				#set_cell(0, Vector2i(x,y),0,Vector2i(0,0))
			#elif noise_value < 0.2:
				#print("l1")
				#set_cell(1, Vector2i(x,y),0,Vector2i(0,0))
			#else:
				#print("l2")
				#set_cell(2, Vector2i(x,y),0,Vector2i(0,0))  
