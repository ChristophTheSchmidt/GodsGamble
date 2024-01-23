extends CanvasLayer

signal generate_world_pressed()

@onready var GenerateButton: Button = $PanelContainer/VBoxContainer/GenerateButton
@onready var seed_text_edit: TextEdit = %SeedTextEdit

@onready var sea: TextEdit = %Sea
@onready var plane: TextEdit = %Plane
@onready var mountains: TextEdit = %Mountains

func _ready():
	GenerateButton.button_up.connect(_on_generate_world_button_pressed)

func _on_generate_world_button_pressed()->void:
	#sea.text.is_valid_int() and\
	if plane.text.is_valid_int() and mountains.text.is_valid_int():
		#treshold_array must be one shorter than the actual count 
		#of different terrain types: The lowest type is always sea
		var dict_percentil_thresholds: Dictionary = {
			&"water" : {
				&"lower_limit" : &"min",
				&"upper_limit" : 15, #clamp(int(plane.text),1,99),
				&"layer"       : 0,
				&"atlas_coordinates" : [Vector2i(1,0)]
			},
			&"plain" : {
				&"lower_limit" : 15,#clamp(int(plane.text),1,99),
				&"upper_limit" : 48,#clamp(int(mountains.text),1,99),
				&"layer"       : 1,
				&"atlas_coordinates" : [Vector2i(0,0)]
			},
			&"hilly_plains" : {
				&"lower_limit" : 48,
				&"upper_limit" : 80,
				&"layer"       : 2,
				&"atlas_coordinates" : [Vector2i(0,2),Vector2i(1,2),Vector2i(2,2)]
			},
			&"mountains" : {
				&"lower_limit" : 80,
				&"upper_limit" : 95,
				&"layer"       : 3,
				&"atlas_coordinates" : [Vector2i(0,1),Vector2i(1,1),Vector2i(2,1)]
			},
			&"high_mountains" : {
				&"lower_limit" : 95,
				&"upper_limit" : &"max",
				&"layer"       : 4,
				&"atlas_coordinates" : [Vector2i(0,4),Vector2i(1,4),Vector2i(2,4)]
			},
		}
		var seed: int = 0
		if seed_text_edit.text.is_valid_int():
			seed = int(seed_text_edit.text)
		generate_world_pressed.emit(dict_percentil_thresholds, seed)
		print(dict_percentil_thresholds)
		pass
