extends Node

@onready var tm1: TileMap = $"1"

@export var noise_height_texture: NoiseTexture2D
var noise: Noise
@export var world_size: = 1000
var noise_val_array: Array[float]
var noise_val_range: float
@export var noise_val_threshhold_count: float = 20.0 #5%
var noise_val_threshholds_array = []
var saved_coordinates: Array[Vector2i]
@export var chosen_thresholds: Array[int] = [
	9, #20% -> Plain, below water
	13, #X% -> mountains
	]
var source_id: int = 0
var atlas_all: = Vector2i(0,0)

func _ready():
	noise = noise_height_texture.noise
	generate_world()


func generate_world()->void:
	for x in range(1000):
		for y in range(1000):
			var noise_val: = noise.get_noise_2d(x,y)
			noise_val_array.append(noise_val)
			saved_coordinates.append(Vector2i(x,y))
	print("max: ",noise_val_array.max())
	print("min: ",noise_val_array.min())
	noise_val_range = abs(noise_val_array.min()) + abs(noise_val_array.max())
	print("range: ",noise_val_range)
	
	var step: float = noise_val_range / noise_val_threshhold_count
	
	noise_val_threshholds_array.append(noise_val_array.min())
	
	for i: float in range(noise_val_threshhold_count -1):
		noise_val_threshholds_array.append(noise_val_threshholds_array[-1] + step)
	
	print("thresholds: ",noise_val_threshholds_array)
	
	#Choosing tiles
	var index: = 0
	for noise_val: float in noise_val_array:
		if noise_val < noise_val_threshholds_array[chosen_thresholds[0]]:
			#place water
			tm1.set_cell(0,saved_coordinates[index],source_id,Vector2i(1,0))
		if noise_val >= noise_val_threshholds_array[chosen_thresholds[0]]:
			tm1.set_cell(0,saved_coordinates[index],source_id,Vector2i(0,0))
			#place plain
		if noise_val >= noise_val_threshholds_array[chosen_thresholds[1]]:
			#place mountain
			tm1.set_cell(0,saved_coordinates[index],source_id,Vector2i(2,0))
			pass
		index += 1
