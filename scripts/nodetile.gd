class_name NodeTile extends Node

var coord : Vector2i
var connections : Array[Connection]

func _init(coordArg=null):
	coord = coordArg

func calcNeighConnections() -> Array[Connection]:
	var tempConns : Array[Connection] = []
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			var neighCoord : Vector2i = Vector2i(coord.x-i,coord.y-j)
			if neighCoord == coord:
				continue
			var conn : Connection = Connection.new(NodeTile.new(coord),NodeTile.new(neighCoord))
			tempConns.append(conn)
	return tempConns
	

func getConnections() -> Array:
	if connections.size() == 0:
		connections = calcNeighConnections()
	return connections

func _to_string():
	return str(coord)
