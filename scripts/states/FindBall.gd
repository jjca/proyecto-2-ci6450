class_name FindBall extends State

@onready var BaseMap : Map = $"../../%Map"
@onready var map : TileMapLayer = $"../../%Map/Ground"
@onready var obstacles : TileMapLayer = $"../../%Map/Obstacles"
@onready var gridmap : Gridlines = $"../../%Map/GridLines"
@export var player : Player
@export var move_speed := 300.0
@export var target : RigidBody2D

var AStarProc : AStar
var grafo : Graph
var heuristic : Heuristic
var cell_size = Vector2i(64,64)
var foundball : bool


func _ready():
	grafo = Graph.new()
	heuristic = Heuristic.new()
	AStarProc = AStar.new()

func findBall(targetPos : Vector2i):
	var destPos = targetPos/64
	var cell_data = obstacles.get_cell_tile_data(destPos)
	if cell_data:
		if !cell_data.get_custom_data("is_walkable"):
			return
	moveFromTo(player.position,destPos,0.05)
	
func Enter():
	target = get_tree().get_nodes_in_group("Pelotas").pick_random()
	findBall(target.position)
	
func Update(delta: float):
	if foundball:
		Transitioned.emit(self,"wandering")
		
func Exit():
	var new_position = Vector2(randi_range(1,15),randi_range(1,15))
	var validposition = false
	while !validposition:
		if BaseMap.isValidTile(new_position):
			validposition = true
		else:
			new_position = Vector2(randi_range(3,15),randi_range(3,15))
	target.position = new_position * tilesize
	foundball = false
	
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
			foundball = true

func moveFromTo(currentPos : Vector2i, destPos :Vector2i,delta :float):
	var from = NodeTile.new(map.local_to_map(currentPos))
	var to = NodeTile.new(destPos)
	print("sabe adonde e?",to.coord)
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
