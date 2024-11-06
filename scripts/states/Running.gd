class_name Running extends State

@export var player: Player
@export var move_speed := 600.0

var move_direction : Vector2
var distance : float
var old_position : Vector2

func randomize_running():
	move_direction.x = 0
	move_direction.y = 1
	move_direction = move_direction.normalized()
	
func Enter():
	#player.path_line.default_color = Color(1, 1, 1, 1)
	randomize_running()
		
func Physics_Update(delta: float):
	if player:
		player.velocity = move_direction * move_speed
	
	distance = player.position.distance_to(old_position)
	
	if distance > 100:
		Transitioned.emit(self,"wandering")
	
	player.move_and_slide()
