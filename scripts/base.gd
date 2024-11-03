extends Node

@onready var ground: TileMapLayer = %Map/Ground
@onready var lines: TileMapLayer = %Map/Lines
@onready var elements: TileMapLayer = %Map/Elements
@onready var net: TileMapLayer = %Map/Net

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event):
	if Input.is_action_just_pressed("ui_text_backspace"):
		var mouseGlobalCoord : Vector2 = ground.get_global_mouse_position()
		var tileCoord : Vector2 = ground.local_to_map(mouseGlobalCoord)
		var list = ground.get_surrounding_cells(tileCoord)
		for i in list:
			ground.erase_cell(i)
		var grafo = Graph.new()
		var heuristic = Heuristic.new()
		var from = NodeTile.new(Vector2i(1,5))
		var to = NodeTile.new(Vector2i(51,80))
		heuristic.goalNode = to
		var AStarVar = AStar.new()
		var result = AStarVar.astar(grafo,from,to,heuristic)
		
		print(result)
