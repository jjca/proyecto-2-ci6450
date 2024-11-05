extends CharacterBody2D

@export var SPEED := 300.0

@onready var timerr = $Timer
@onready var BaseMap : Map = %Map
@onready var map : TileMapLayer = %Map/Ground
@onready var obstacles : TileMapLayer = %Map/Obstacles
@onready var gridmap : TileMapLayer = %Map/GridLines
var tilesize = 64
var snapp = Vector2.ONE * tilesize
@onready var path_line: Line2D = $PathLine
var moving = false
var global_path : Array
var current_target_index = 0

var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

enum States {IDLE, WANDERING, WALKING}

var state : States = States.IDLE

func _ready():
	print(position)
	position = position.snapped(Vector2.ONE * tilesize)
	position += Vector2.ONE * tilesize/2

func _unhandled_input(event: InputEvent) -> void:
	if moving:
		return
	if event.is_action_pressed("F"):
		var destPos = Vector2i(randi_range(0,15),randi_range(0,11))
		var cell_data = obstacles.get_cell_tile_data(destPos)
		print("Salio:",destPos)
		if cell_data:
			if !cell_data.get_custom_data("is_walkable"):
				return
		moveFromTo(position,destPos,0.05)
	if event.is_action_pressed("H"):
		var destPos = Vector2i(randi_range(0,5),randi_range(0,15))
		moveFromTo(self.position,destPos,0.05)
		while global_path.size() > 0:
			var conn : Connection = global_path.pop_front()
			var pos = conn.toNode.coord * tilesize
			moveToTile(pos)
			rotation = lerp(self.rotation,self.position.direction_to(pos).angle(),0.5)
			path_line.global_rotation = 0
			#self.velocity = self.global_position.direction_to(pos.snapped(snapp)) * 100 *delta # - self.position.snapped(snapp)
			#self.velocity = new_vel.normalized() * SPEED
			#self.position = pos
			set_path_line(global_path)
			if map.local_to_map(position) == destPos:
				print("??")
				position += snapp/2
				velocity = Vector2.ZERO
				await get_tree().create_timer(0.5,true,true).timeout
				path_line.clear_points()
				break
				
			await get_tree().create_timer(0.5,true,true).timeout

	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
		
func move(dir):
	var tween = create_tween()
	tween.tween_property(self, "position",position + inputs[dir] * tilesize,
	1.0/3).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false
	
func moveToTile(coord):
	var tween = create_tween()
	tween.tween_property(self, "position",position + position.direction_to(coord) * tilesize,
	1.0/3).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false

func moveFromTo(currentPos : Vector2i, destPos :Vector2i,delta :float):
	var from = NodeTile.new(map.local_to_map(currentPos))
	var to = NodeTile.new(destPos)
	global_path = BaseMap.findPath(from,to,BaseMap)
	if global_path == null:
		global_path = []
	print("el camino es: ",global_path)
	var final_path : PackedVector2Array
	for p in global_path:
		final_path.append(p.getToNode().coord)
	gridmap.cells = final_path

func _physics_process(delta: float) -> void:
	#path_line.global_rotation = 0
	#var input_direction = Vector2(
	#	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
	#	Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#)
	
	#if input_direction.length() > 1.0:
	#	input_direction = input_direction.normalized()
	#velocity = input_direction * 300
	#rotation = input_direction.angle()
	
	
	#if (velocity.normalized().x == -1):
	#	rotation = -PI
	#elif (velocity.normalized().y == -1):
	#	rotation = 3*PI/2
	#elif (velocity.normalized().y == 1):
	#	rotation = PI/2
	#elif (velocity.normalized().x == 1):
	#	rotation = 0
	#var input_direction_x = Input.get_axis("ui_left","ui_right")
	
	#if state == States.IDLE:
	#	velocity = Vector2.ZERO
	#elif state in [States.WANDERING, States.WALKING]:
	#	velocity.x = input_direction_x * 100
	#move_and_slide()
	if global_path and global_path.size() > 0:
		set_path_line(global_path)
		var conn : Connection = global_path[current_target_index]
		var target_pos : Vector2i = conn.toNode.coord * tilesize
		position.x = target_pos.x
		position.y = target_pos.y
		#moveToTile(pos)
		await get_tree().create_timer(0.5,true,true).timeout
		#rotation = lerp(self.rotation,self.position.direction_to(pos).angle(),0.5)
		path_line.global_rotation = 0
			#self.velocity = self.global_position.direction_to(pos.snapped(snapp)) * 100 *delta # - self.position.snapped(snapp)
			#self.velocity = new_vel.normalized() * SPEED
		if position.distance_to(target_pos) < 1.0:
			global_path.remove_at(0)
		#rotation = lerp(self.rotation,self.position.direction_to(pos).angle(),0.5)
		#path_line.global_rotation = 0
		#self.velocity = self.global_position.direction_to(pos).normalized() * 100 * delta
		#print(self.position.direction_to(pos).normalized())
		#await get_tree().create_timer(0.5,true,true).timeout
		#set_path_line(global_path)
	if global_path.size() == 0:
		path_line.clear_points()
		velocity = Vector2.ZERO
	

func set_path_line(points : Array[Connection]):
	var local_points := []
	print("los cdsm",points)
	for point in points:
		if point == points[0]:
			local_points.append(Vector2.ZERO)
		else:
			local_points.append(map.map_to_local(point.fromNode.coord) - global_position)
	local_points.append(map.map_to_local(points.back().toNode.coord)-global_position)
	path_line.points = local_points
