extends CharacterBody2D

@onready var timerr = $Timer 
const SPEED = 300.0
@onready var BaseMap : TileMapLayer = %Map
@onready var map : TileMapLayer = %Map/Ground
@onready var elements : TileMapLayer = %Map/Elements
var tilesize = 64
var snapp = Vector2.ONE * tilesize
@onready var path_line: Line2D = $PathLine
var moving = false

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
	

func moveFromTo(currentPos : Vector2i, destPos :Vector2i,delta :float):
	var from = NodeTile.new(map.local_to_map(currentPos).snapped(snapp))
	var to = NodeTile.new(destPos)
	var path : Array[Connection] = BaseMap.findPath(from,to)
	return path

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
		var destPos = Vector2i(3,7)
		var path = moveFromTo(position,destPos,0.05)
		while path.size() > 0:
			
			var conn : Connection = path.pop_front()
			var pos = map.map_to_local(conn.toNode.coord)
			#rotation = lerp(self.rotation,self.position.direction_to(pos).angle(),0.5)
			path_line.global_rotation = 0
			self.velocity = self.global_position.direction_to(pos.snapped(snapp)) * 100 # - self.position.snapped(snapp)
			#self.velocity = new_vel.normalized() * SPEED
			
			
			self.position = pos
			set_path_line(path)
			await get_tree().create_timer(0.5,true,true).timeout
			
			#kkprint(position.snapped(snapp))
			#print("!!!",pos.snapped(snapp))
			#print(map.local_to_map(position))
			#print(map.local_to_map(pos))
			if map.local_to_map(position) == destPos:
				print("??")
				#position -= snapp/2
				velocity = Vector2.ZERO
				path_line.clear_points()
			
			move_and_slide()

func set_path_line(points : Array[Connection]):
	var local_points := []
	for point in points:
		if point == points[0]:
			local_points.append(Vector2.ZERO)
		else:
			local_points.append(map.map_to_local(point.fromNode.coord) - global_position)
	path_line.points = local_points
