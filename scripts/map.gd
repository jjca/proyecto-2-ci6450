extends TileMapLayer

var AStarProc : AStar
var grafo : Graph
var heuristic : Heuristic

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
