extends Node

@onready var world_generator = %WorldGenerator
@onready var world_gen_ui = %WorldGenUI

func _ready():
	world_gen_ui.generate_world_pressed.connect(world_generator.generate_world)
