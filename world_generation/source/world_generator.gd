#@tool
class_name WorldGenerator extends Node2D
## My Class for generating a world from a noise texture and displaying the
## generated information on a TileMap

#region All members to be set in the editor (except seed)
## This is the TileMap generration is applied on
@export_node_path("TileMap") var tile_map_path
## World size as a square
@export_range(100, 1000, 100) var world_size: int = 100

@export_group("Noise","")
@export_subgroup("Base Height Noise (bh)") # Later come continents, rivers etc.
## Source ID of the TileMaps Atlas containing Tiles for base height
@export_range(1,10,1) var atlas_source_id: int = 0
## NoiseTexture from which the _base_height_noise is taken
@export var noise_texture: NoiseTexture2D

@export_subgroup("Geology Noise (g)") 
@export var g_noise_texture: NoiseTexture2D

#endregion

## Is called by clicking generate in WorldGEnUI
## and providing the thresholds for each new type of terrain.
## dict_percentil_thresholds is an dict containing the percentil values of all thresholds.
## Values must be in ascending order and range from 1 to 99.
## If they go over 99 or under 1 the indexing does not work.
func generate_world(
	dict_percentil_thresholds: Dictionary,
	seed: int
	)->void:
#region Get all noise values for each coordinate
	
	# All noise values in an array
	var array_noise_values: Array[float] = []
	
	# An array containing the positions corresponding to the noise values
	var array_positions: PackedVector2Array
	
	# save value and corresponding position
	var noise: Noise = noise_texture.noise
	if seed != 0:
		noise.seed = seed
	for x in range(-world_size/2,world_size/2):
		for y in range(-world_size/2,world_size/2):
			var current_noise_value: = noise.get_noise_2d(x,y)
			array_noise_values.append(current_noise_value)
			array_positions.append(Vector2i(x,y))
#endregion
	
#region Value range
	
	# The range of the values from the NoiseTexture
	# This is just for interest and will not get used because
	# the percentils of all values are better to work with
	var noise_min:   float = array_noise_values.min()
	var noise_max:   float = array_noise_values.max()
	var noise_range: float = abs(noise_min) + abs(noise_max)
	print(
		"Min/Max: %s / %s. Range of noise values: %s" 
		% [noise_min,noise_max,noise_range]
	)
	
	# Instead of using the range I use percentils
	# For that I need to a copy of the values and sort them (just the copy) 
	var _sorted_noise: = array_noise_values.duplicate()
	_sorted_noise.sort()
	#_sorted_noise.reverse()
	var _one_percent_step_index: int = world_size * world_size / 100
	#for percentage_treshold: int in dict_percentil_thresholds:
		#var current_threshold_value: = Vector3(
			#percentage_treshold,
			#percentage_treshold * _one_percent_step_index,
			#_sorted_noise[percentage_treshold * _one_percent_step_index]
		#)
	
	
	
	# Fill in missing values in dict_percentil_thresholds
	# especially min and max
	for terrain: StringName in dict_percentil_thresholds:
		for limit: StringName in [&"lower_limit",&"upper_limit"]:
			match dict_percentil_thresholds[terrain][limit]:
				&"min": 
					dict_percentil_thresholds[terrain][limit] = noise_min
				&"max":
					dict_percentil_thresholds[terrain][limit] = noise_max
				var value:
					assert(value is int)
					print_debug(
						"Setting %s of terrain %s to value %s with index %s" %\
						[limit,terrain,_sorted_noise[value * _one_percent_step_index],value * _one_percent_step_index]
					)
					dict_percentil_thresholds[terrain][limit] =\
						_sorted_noise[value * _one_percent_step_index]
#endregion
	var tile_map: TileMap = get_node(tile_map_path)
	tile_map.clear()
	for index in len(array_noise_values):
		_get_and_set_cell(
			tile_map,
			array_noise_values,
			array_positions,
			index,
			dict_percentil_thresholds
		)

func _get_and_set_cell(
	tile_map: TileMap,
	array_noise_values: Array[float],
	array_positions: Array[Vector2i],
	index: int,
	dict_percentil_thresholds: Dictionary
)->void:
	var fit_somewhere: = false
	for terrain: StringName in dict_percentil_thresholds:
		#TODO: Error: Invalid get index 'lower_limit' on base Dictionary
		if array_noise_values[index] >= dict_percentil_thresholds[terrain][&"lower_limit"]\
		and array_noise_values[index] <= dict_percentil_thresholds[terrain][&"upper_limit"]: #<= to not let the highest values without a terrain
			tile_map.set_cell(
				dict_percentil_thresholds[terrain][&"layer"],
				array_positions[index],
				0, #source_id
				dict_percentil_thresholds[terrain][&"atlas_coordinates"].pick_random()
			)
			fit_somewhere = true
	assert(fit_somewhere)
