# terrain_data.gd
extends Resource
class_name TerrainCell

# Basic properties per cell
var x: int
var y: int
var height: float = 0.0
var temperature: float = 0.0
var moisture: float = 0.0
var biome: BiomeData = null

# Flags for features
var is_river: bool = false
var is_settlement_candidate: bool = false

# Constructor
func _init(_x: int, _y: int):
	x = _x
	y = _y
