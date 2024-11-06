class_name Idle extends State

@export var player: Player

var idle_timing : float

func idle():
	player.velocity = Vector2.ZERO
	idle_timing = randf_range(0,5)
	
func Enter():
	idle()
		
func Physics_Update(delta: float):

	if idle_timing < 1:
		Transitioned.emit(self, "Wandering")
	else:
		idle_timing -= delta
