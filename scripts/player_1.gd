extends CharacterBody2D

@onready var timerr = $Timer 
const SPEED = 300.0
@onready var BaseMap : TileMapLayer = %Map
@onready var map : TileMapLayer = %Map/Ground
@onready var elements : TileMapLayer = %Map/Elements
@onready var gridmap : TileMapLayer = %Map/GridLines
var tilesize = 64
var snapp = Vector2.ONE * tilesize
@onready var path_line: Line2D = $PathLine
var moving = false
var global_path

var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

func _ready():
	position = position.snapped(Vector2.ONE * tilesize)
	position += Vector2.ONE * tilesize/2

func _unhandled_input(event: InputEvent) -> void:
	if moving:
		return
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
	print("papita")
	var tween = create_tween()
	tween.tween_property(self, "position",position + inputs[dir] * tilesize,
	1.0/3).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false
	
func moveToTile(coord):
	print("owos")
	var tween = create_tween()
	tween.tween_property(self, "position",position + position.direction_to(coord) * tilesize,
	1.0/3).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false

func moveFromTo(currentPos : Vector2i, destPos :Vector2i,delta :float):
	var from = NodeTile.new(map.local_to_map(currentPos))
	var to = NodeTile.new(destPos)
	print("se buscara desde:",from)
	print("Hasta",to)
	global_path = BaseMap.findPath(from,to)
	var final_path : PackedVector2Array
	for p in global_path:
		final_path.append(p.getToNode().coord)
	gridmap.cells = final_path
	return global_path

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
	if Input.is_action_pressed("F"):
		var destPos = Vector2i(randi_range(0,5),randi_range(0,15))
		moveFromTo(position,destPos,0.05)
		
		while global_path.size() > 0:
			var conn : Connection = global_path.pop_front()
			#var pos = map.map_to_local(conn.toNode.coord)
			var pos = conn.toNode.coord * tilesize
			#rotation = lerp(self.rotation,self.position.direction_to(pos).angle(),0.5)
			path_line.global_rotation = 0
			
			self.velocity = self.global_position.direction_to(pos) * 100 # - self.position.snapped(snapp)
			#self.velocity = new_vel.normalized() * SPEED
			
			
			#self.position = pos
			set_path_line(global_path)
			await get_tree().create_timer(0.5,true,true).timeout
			
			#kkprint(position.snapped(snapp))
			#print("!!!",pos.snapped(snapp))
			#print(map.local_to_map(position))
			#print(map.local_to_map(pos))
			move_and_slide()
				#position -= snapp/2
		velocity = Vector2.ZERO
		path_line.clear_points()
			
			

func set_path_line(points : Array[Connection]):
	var local_points := []
	for point in points:
		if point == points[0]:
			local_points.append(Vector2.ZERO)
		else:
			local_points.append(map.map_to_local(point.fromNode.coord) - global_position)
	path_line.points = local_points
