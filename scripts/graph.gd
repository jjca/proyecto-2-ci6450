class_name Graph extends Node2D

var nodes : Array = []

func getConnections(fromNode: NodeTile) -> Array:
	return fromNode.getConnections()
