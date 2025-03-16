# biome_data.gd
extends Resource
class_name BiomeData

@export var name: String
@export var elevation_thresholds: Array[float]
@export var tile_ids: Array[int]  # Corresponding tile IDs or atlas coords
@export var temperature: float
@export var moisture: float
@export var weight: float = 1.0 # Used in biome selection probability
