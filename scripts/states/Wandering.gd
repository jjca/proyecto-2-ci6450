class_name Wandering extends State

@export var player: CharacterBody2D
@export var move_speed := 100.0

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	move_direction.x = randi_range(-1,1)
	if move_direction.x == 1:
		move_direction.y = 0
	elif move_direction.x == 0:
		move_direction.y = randi_range(-1,1)
	elif move_direction.x == -1:
		move_direction.y = 0
	move_direction = move_direction.normalized()
	wander_time = randf_range(1,5)
	
func Enter():
	randomize_wander()
	
func Update(delta: float):
	if wander_time > 0 and wander_time < 5:
		wander_time -= delta
	elif wander_time == 5:
		Transitioned.emit(self,"Running")
	else:
		randomize_wander()
		
func Physics_Update(delta: float):
	if player:
		player.velocity = move_direction * move_speed
