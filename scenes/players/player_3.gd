class_name Player3 extends Player

@onready var wandertimer: Timer = $Timer

var running : bool = false


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
	if state_machine.current_state.name == "wandering":
		wandertimer.start()
				
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
	if body.is_in_group("Pelotas"):
		state_machine.current_state.Transitioned.emit(state_machine.current_state,"findball")
			
	
func _on_timer_timeout() -> void:
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"running")
	running = true
