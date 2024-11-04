extends CharacterBody2D

@onready var timerr = $Timer 
const SPEED = 300.0
@onready var BaseMap : TileMapLayer = %Map
@onready var map : TileMapLayer = %Map/Ground
@onready var elements : TileMapLayer = %Map/Elements
var tilesize = 64
var snapp = Vector2.ONE * tilesize

func moveFromTo(currentPos : Vector2i, destPos :Vector2i,delta :float):
	var from = NodeTile.new(map.local_to_map(currentPos).snapped(snapp))
	var to = NodeTile.new(destPos)
	var path : Array[Connection] = BaseMap.findPath(from,to)
	while path.size() > 0:
		var conn : Connection = path.pop_front()
		var pos = map.map_to_local(conn.toNode.coord)
		var new_vel = pos.snapped(snapp) - self.position.snapped(snapp)
		self.velocity = new_vel.normalized() * SPEED
		#self.velocity = new_vel
		# position = pos
		await get_tree().create_timer(0.5,true,true).timeout
		
		print(position.snapped(snapp))
		print("!!!",pos.snapped(snapp))
		print(map.local_to_map(position))
		print(map.local_to_map(pos))
		if map.local_to_map(position) == destPos:
			print("??")
			#position -= snapp/2
			velocity = Vector2.ZERO
			return
		move_and_slide()
		
		
	velocity = Vector2.ZERO
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F:
			moveFromTo(position,Vector2i(3,7),0.05)

func _physics_process(delta: float) -> void:
	
	var input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	if (velocity.normalized().x == -1):
		rotation = -PI	
	elif (velocity.normalized().y == -1):
		rotation = 3*PI/2
	elif (velocity.normalized().y == 1):
		rotation = PI/2
	elif (velocity.normalized().x == 1):
		rotation = 0

	move_and_slide()
