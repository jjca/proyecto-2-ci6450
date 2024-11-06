class_name Player2 extends Player


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
	#print(state_machine.states)
	#print(state_machine.states.values())
	#print(state_machine.states.get("wandering"))
	#print(state_machine.states.keys())
	if state_machine.current_state.name == "Stalking":
		stalking = true
		timerr.start()
		
	if state_machine.current_state.name != "Wandering" and !stalking:
		state_machine.current_state.Transitioned.emit(state_machine.current_state,"wandering")
	#else:
	#	state_machine.states["running"].Enter()
		
		
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
	print(state_machine.current_state)
	print(body.name)
	if body.name == "Player2":
		#print("mira si!")
		if state_machine.current_state.name != "Stalking":
			state_machine.current_state.Transitioned.emit(state_machine.current_state,"stalking")
		#	print("stalkeando")
		#	print(state_machine.current_state)
		#	print("pues no mi ciela")
			
	


func _on_timer_timeout() -> void:
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"wandering")
	#print("se acabó el acoso")
	stalking = false
