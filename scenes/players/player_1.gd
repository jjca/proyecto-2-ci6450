extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	
	var input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	velocity = input_direction * SPEED
	
	print(velocity.normalized())
	
	if (velocity.normalized().x == -1):
		rotation = -PI	
	elif (velocity.normalized().y == -1):
		rotation = 3*PI/2
	elif (velocity.normalized().y == 1):
		rotation = PI/2
	elif (velocity.normalized().x == 1):
		rotation = 0
	move_and_slide()
