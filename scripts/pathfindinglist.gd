class_name PathfindingList extends Node

var costSoFar : float 
var list : Array[NodeRecord]

func _init():
	list = []
	costSoFar = 0
	
func smallestElement() -> NodeRecord:
	var minimo = list[-1]
	for i in list:
		if i.getEstimatedTotalCost() < minimo.getEstimatedTotalCost():
			minimo = i
	return minimo

func nodeTileInList(nodeToSearch: NodeTile) -> bool:
	for i in list:
		if i.node.coord == nodeToSearch.coord:
			return true
	return false

func getNodeRecord(nodeToSearch: NodeTile) -> NodeRecord:
	for i in list:
		if i.node.coord == nodeToSearch.coord:
			return i
	return null
