extends Node
class_name BiomeManager

# BiomeData resources list (drop your .tres files into this array via Inspector)
@export var biome_list: Array[BiomeData]

# Optional: default biome fallback
@export var default_biome: BiomeData

func _ready():
	# Safety check: make sure you have biomes loaded
	if biome_list.is_empty():
		push_warning("BiomeManager: No biomes loaded!")

# Gets the biome based on temperature and moisture input
func get_biome(temperature: float, moisture: float) -> BiomeData:
	for biome in biome_list:
		if temperature >= biome.min_temperature and temperature <= biome.max_temperature and \
		   moisture >= biome.min_moisture and moisture <= biome.max_moisture:
			return biome
	
	# If no biome matches, return default biome (optional)
	if default_biome:
		return default_biome
	
	push_warning("BiomeManager: No biome found! Returning null.")
	return null
