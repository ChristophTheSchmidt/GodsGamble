extends CharacterBody2D

const SPEED: int = 150

func _physics_process(delta):
	velocity = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up","ui_down")
	).normalized() * SPEED
	
	move_and_slide()
