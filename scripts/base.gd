extends Node

@onready var ground: TileMapLayer = %Map/Ground
@onready var lines: TileMapLayer = %Map/Lines
@onready var obstacles: TileMapLayer = %Map/Obstacles
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var camera_2d: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(character_body_2d.position)
	print(character_body_2d.global_position)

func _input(event):
	if Input.is_action_just_pressed("ui_text_backspace"):
		var mouseGlobalCoord : Vector2 = ground.get_global_mouse_position()
		var tileCoord : Vector2 = ground.local_to_map(mouseGlobalCoord)
		var list = ground.get_surrounding_cells(tileCoord)
		print(tileCoord)
		for i in list:
			ground.erase_cell(i)
	if Input.is_action_just_released('-'):
		camera_2d.set_zoom(camera_2d.get_zoom() - Vector2(0.25, 0.25))
	if Input.is_action_just_released('+'): #and get_zoom() > Vector2.ONE:
		camera_2d.set_zoom(camera_2d.get_zoom() + Vector2(0.25, 0.25))

		#var grafo = Graph.new()
		#var heuristic = Heuristic.new()
		#var from = NodeTile.new(ground.local_to_map(character_body_2d.position))
		#var to = NodeTile.new(Vector2i(3,7))
		#heuristic.goalNode = to
		#var AStarVar = AStar.new()
		#var result = AStarVar.astar(grafo,from,to,heuristic)
		#for i in result:
		#	character_body_2d.move_and_slide(ground.map_to_local(i.toNode.coord).normalized()*200)
		#print(character_body_2d.position)
		#print(result)
