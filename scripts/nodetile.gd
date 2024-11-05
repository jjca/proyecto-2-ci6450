class_name NodeTile extends Node

@onready var grid_lines: TileMapLayer = $GridLines
@onready var lines: TileMapLayer = $Lines
@onready var net: TileMapLayer = $Net
@onready var elements: TileMapLayer = $Elements

var coord : Vector2i
var connections : Array[Connection]

func _init(coordArg=null):
	coord = coordArg

func calcNeighConnections() -> Array[Connection]:
	connections = [
	Connection.new(NodeTile.new(coord),NodeTile.new(Vector2i(coord.x+1,coord.y))),
	Connection.new(NodeTile.new(coord),NodeTile.new(Vector2i(coord.x-1,coord.y))),
	Connection.new(NodeTile.new(coord),NodeTile.new(Vector2i(coord.x,coord.y+1))),
	Connection.new(NodeTile.new(coord),NodeTile.new(Vector2i(coord.x,coord.y-1))),
	]
	return connections

func getConnections() -> Array:
	if connections.size() == 0:
		connections = calcNeighConnections()
	return connections

func _to_string():
	return str(coord)
