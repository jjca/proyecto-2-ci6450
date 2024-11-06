class_name Player2 extends Player

var fleeing : bool

@onready var timerflee: Timer = $Timer
@onready var timer_2: Timer = $Timer2

func _ready():
	position = position.snapped(Vector2.ONE * tilesize)
	position += Vector2.ONE * tilesize/2

func _unhandled_input(event: InputEvent) -> void:
	if moving:
		return
		
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			#move(dir)
			pass

func _physics_process(delta: float) -> void:
	
	pass

func set_path_line(points : Array[Connection]):
	var local_points := []
	for point in points:
		if point == points[0]:
			local_points.append(Vector2.ZERO)
		else:
			local_points.append(map.map_to_local(point.fromNode.coord) - global_position)
	local_points.append(map.map_to_local(points.back().toNode.coord)-global_position)
	path_line.points = local_points

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print(state_machine.current_state)
	#print(body.name)
	if body.name == "Player1":
		print("run forrest")
		if state_machine.current_state.name != "Fleeing":
			fleeing = true
			timerflee.start()
			state_machine.current_state.Transitioned.emit(state_machine.current_state,"fleeing")
			

func _on_timer_timeout() -> void:
	if state_machine.current_state.name == "idle":
		return
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"wandering")
	fleeing = false

func _on_timer_2_timeout() -> void:
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"idle")
