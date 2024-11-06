class_name Player extends CharacterBody2D

@export var SPEED := 300.0
@onready var timerr = $Stalking_Timer
@onready var BaseMap : Map = %Map
@onready var map : TileMapLayer = %Map/Ground
@onready var obstacles : TileMapLayer = %Map/Obstacles
@onready var gridmap : Gridlines = %Map/GridLines
@onready var state_machine: StateMachine = $StateMachine

var stalking : bool = false
var tilesize = 64
var snapp = Vector2.ONE * tilesize
@onready var path_line: Line2D = $PathLine
var moving = false
var global_path : Array
var current_target_index = 0

var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

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
	if body.name == "Player2":
		if state_machine.current_state.name != "Stalking":
			state_machine.current_state.Transitioned.emit(state_machine.current_state,"stalking")


func _on_timer_timeout() -> void:
	stalking = false
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"wandering")
	
