extends CharacterBody2D

const PAN_SPEED: int = 1000
const ZOOM_SPEED: = Vector2(.1,.1)
const MIN_ZOOM: = Vector2(.1,.1)
const MAX_ZOOM: = Vector2(5.,5.)
const DRAG_SENSITIVITY: = 2.0
var   do_move: bool = false
@onready var camera_2d = $Camera2D


func _physics_process(_delta):
	velocity = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up","ui_down")
	).normalized() * PAN_SPEED
	move_and_slide()
	
	if Input.is_action_just_released("zoom_in"):
		camera_2d.zoom = clamp(camera_2d.zoom + ZOOM_SPEED,MIN_ZOOM, MAX_ZOOM)
	if Input.is_action_just_released("zoom_out"):
		camera_2d.zoom = clamp(camera_2d.zoom - ZOOM_SPEED,MIN_ZOOM, MAX_ZOOM)

# The panning drags on a while after releasing
# I dont know how to stop it
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		#if event.is_released(MOUSE_BUTTON_LEFT): return
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			# Minus because the camera moves in the camera moves in the opposite direction
			# event.relative is the difference from last mousemotion to current
			position -= event.relative * DRAG_SENSITIVITY / camera_2d.zoom 
