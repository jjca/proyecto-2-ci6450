class_name Connection extends Node

var fromNode: NodeTile
var toNode : NodeTile
var cost : float

func _init(fromNodeArg=null,toNodeArg=null):
	fromNode = fromNodeArg
	toNode = toNodeArg
	var fromVect = fromNode.coord
	var toVect = toNode.coord
	#print(fromVect.distance_to(toVect))
	cost = fromVect.distance_to(toVect)

func getCost() -> float:
	return cost

func getFromNode() -> NodeTile:
	return fromNode

func getToNode() -> NodeTile:
	return toNode

func _to_string() -> String:
	return fromNode._to_string() + " -> " + toNode._to_string()+ "\n"
