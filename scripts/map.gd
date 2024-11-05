extends TileMapLayer

var AStarProc : AStar
var grafo : Graph
var heuristic : Heuristic
var cell_size = Vector2i(64,64)
var grid_size = Vector2i(get_viewport_rect().size) / cell_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grafo = Graph.new()
	heuristic = Heuristic.new()
	AStarProc = AStar.new()

func findPath(fromVector : NodeTile, toVector : NodeTile):
	heuristic.goalNode = toVector
	var result = AStarProc.astar(grafo,fromVector,toVector,heuristic)
	return result

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
