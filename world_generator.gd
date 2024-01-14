@tool
class WorldGenerator: extends Node2D
## My Class for generating a world from a noise texture and displaying the
## generated information on a TileMap

@export_category("WorldGenerator")
## This is the TileMap generration is applied on
@export_node_path("TileMap") var tile_map 
## World size as a square
@export_range(100, 1000, 100) var world_size: int

@export_group("Noise","")
@export_subgroup("Base Height Noise (bh)") # Later come continents, rivers etc.
## Source ID of the TileMaps Atlas containing Tiles for base height
@export_range(1,10,1) var bh_atlas_source_id: int = 0
## NoiseTexture from which the _base_height_noise is taken
@export var bh_noise_texture: NoiseTexture2D
## Noise taken from the NoiseTexture2D
var _bh_noise: Noise
## All noise values in an array
#TODO: Find out if values from noise and PackedFloat32Array work together
#TODO: Maybe this Array is unnecessary, because I can just iterate over texture again
var _bh_noise_value_array: Array[float]
## An array containing the positions corresponding to the noise values
#TODO: Same as above
var _bh_saved_positions: PackedVector2Array
## The range of the values from the NoiseTexture
## Divided by 100 and then used for thresholds of certain terrain types
var _bh_noise_range: float
## The step size to walk a long the _bh_noise_range in 100 steps
var _bh_noise_value_treshhold_step_size: float
## An array containing the percent values of all thresholds
## Values must be in ascending order and range from 1 to 100.
## They represent the treshold in percent where a new terrain type 
## is assigned to the according noise values.
@export var bh_tresholds: Array[int]
## An array containing the actual noise values of all thresholds
var _bh_noise_value_treshold_array: Array[float]

func generate_world()->void:
	#(bh) Base height section
	
	# Get all noise values for each coordinate
	# save value and corresponding position
	_bh_noise = bh_noise_texture.noise
	for x in range(world_size):
		for y in range(world_size):
			var current_noise_value: = _bh_noise.get_noise_2d(x,y)
			_bh_noise_value_array.append(current_noise_value)
			_bh_saved_positions.append(Vector2(x,y))
	
	# Determine range and percent steps of the noise values
	if _bh_noise_value_array.min() < 0.0 and _bh_noise_value_array.max() > 0.0:
		_bh_noise_range = abs(_bh_noise_value_array.min()) + abs(_bh_noise_value_array.max())
	else:
		print_debug("The range of noise values requires different treatment!")
	
	_bh_noise_value_treshhold_step_size = _bh_noise_range / 100 # 1 step is 1% of the range
	
	#TODO: Continue here!
	_bh_noise_value_treshold_array
	
