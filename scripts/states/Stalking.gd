class_name Stalking extends State

@onready var BaseMap : Map = $"../../%Map"
@onready var map : TileMapLayer = $"../../%Map/Ground"
@onready var obstacles : TileMapLayer = $"../../%Map/Obstacles"
@onready var gridmap : Gridlines = $"../../%Map/GridLines"
@export var player : Player
@export var move_speed := 300.0
@export var target : Player

var target_positon : Vector2

var stalk_time : float
var AStarProc : AStar
var grafo : Graph
var heuristic : Heuristic
var cell_size = Vector2i(64,64)
var walking : bool = false
var maxSpeed : float = 100
var velocity : Vector2 = Vector2.ZERO
var maxAcceleration : float = 30
var minRadius : float = 65
var maxRadius : float = 400
var timeToTarget : float = 0.5
var stalking : bool = false

func _ready():
	grafo = Graph.new()
	heuristic = Heuristic.new()
	AStarProc = AStar.new()
	
func Enter():
	target = get_tree().get_first_node_in_group("Jugadorp")
	stalk()

#func getSteering(target,character):
	#var char_velocity : Vector2 = character.position + target.position
	#char_velocity += char_velocity.normalized() * maxAcceleration
	#if char_velocity.length() > maxRadius:
		#return Vector2.ZERO
	#return char_velocity

func stalk():
	stalking = true
	stalk_time = randf_range(1,5)
	target_positon = map.local_to_map(target.position)
	var distanceToTarget = player.position.distance_to(target_positon)
	print("Dist al target",distanceToTarget)
	if distanceToTarget < 5:
		var cell_data = obstacles.get_cell_tile_data(target_positon)
		if cell_data:
			if !cell_data.get_custom_data("is_walkable"):
				return
		else:
			moveFromTo(player.position,target_positon,0.05)
			return
	
func Update(delta: float):
	if stalk_time > 0 and stalk_time < 2:
		stalk_time -= delta
		stalking = true
	elif stalk_time > 2:
		stalking = false
		
func Physics_Update(delta: float):
	if player.global_path != null and player.global_path.size() > 0:
		player.set_path_line(player.global_path)
		var conn : Connection = player.global_path[player.current_target_index]
		var target_pos : Vector2i = conn.toNode.coord * tilesize + Vector2i.ONE * tilesize/2
		player.position.x = target_pos.x
		player.position.y = target_pos.y
		player.set_path_line(player.global_path)
		await get_tree().create_timer(0.5,true,true).timeout
		player.path_line.global_rotation = 0
		
		if player.position.distance_to(target_pos) < 0.1:
			player.global_path.remove_at(0)

		if player.global_path.size() == 0:
			player.path_line.clear_points()
			player.velocity = Vector2.ZERO
			stalking = false

func moveFromTo(currentPos : Vector2i, destPos :Vector2i,delta :float):
	var from = NodeTile.new(map.local_to_map(currentPos))
	var to = NodeTile.new(destPos)
	player.global_path = findPath(from,to,BaseMap)
	if player.global_path == null:
		player.global_path = []
	#print("el camino es: ",global_path)
	var final_path : PackedVector2Array
	for p in player.global_path:
		final_path.append(p.getToNode().coord)
	gridmap.cells = final_path


func findPath(fromVector : NodeTile, toVector : NodeTile, mapa : Map):
	heuristic.goalNode = toVector
	var result = AStarProc.aStar(grafo,fromVector,toVector, heuristic, mapa)
	return result
