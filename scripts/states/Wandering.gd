class_name Wandering extends State

@onready var BaseMap : Map = $"../../%Map"
@onready var map : TileMapLayer = $"../../%Map/Ground"
@onready var obstacles : TileMapLayer = $"../../%Map/Obstacles"
@onready var gridmap : Gridlines = $"../../%Map/GridLines"
@export var player : Player
@export var move_speed := 100.0
var wandering : bool = false
var wander_time : float
var move_direction : Vector2


var AStarProc : AStar
var grafo : Graph
var heuristic : Heuristic
var cell_size = Vector2i(64,64)

func _ready():
	player = owner
	grafo = Graph.new()
	heuristic = Heuristic.new()
	AStarProc = AStar.new()

func randomize_wander():
	wandering = true
	wander_time = randf_range(1,8)
	var destPos = Vector2i(randi_range(0,15),randi_range(0,11))
	var cell_data = obstacles.get_cell_tile_data(destPos)
	if cell_data:
		if !cell_data.get_custom_data("is_walkable"):
			return
	moveFromTo(player.position,destPos,0.05)
	
func Enter():
	randomize_wander()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else: 
		randomize_wander()
		
func Physics_Update(delta: float):
	if player.global_path and player.global_path.size() > 0:
		player.set_path_line(player.global_path)
		var conn : Connection = player.global_path[player.current_target_index]
		var target_pos : Vector2i = conn.toNode.coord * tilesize + Vector2i.ONE * tilesize/2
		player.position.x = target_pos.x
		player.position.y = target_pos.y
		player.set_path_line(player.global_path)
		await get_tree().create_timer(0.5,true,true).timeout
		player.path_line.global_rotation = 0
		
		if player.position.distance_to(target_pos) < 1.0:
			player.global_path.remove_at(0)

		if player.global_path.size() == 0:
			player.path_line.clear_points()
			player.velocity = Vector2.ZERO
			wandering = false

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
