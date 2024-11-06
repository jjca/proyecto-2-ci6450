class_name Heuristic extends Node

var goalNode : NodeTile

func estimate(node: NodeTile) -> float:
	return estimateFromTo(node, goalNode)
	
func estimateFromTo(fromNode: NodeTile, toNode: NodeTile) -> float:
	var fromVect : Vector2i = fromNode.coord
	var toVect : Vector2i = toNode.coord
	return abs(fromVect.x - toVect.x) + abs(fromVect.y - toVect.y)
