class_name Map extends TileMapLayer

@onready var grid_lines: TileMapLayer = $GridLines
@onready var ground: TileMapLayer = $Ground
@onready var lines: TileMapLayer = $Lines
@onready var obstacles: TileMapLayer = $Obstacles
var is_walkable : String = "is_walkable"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func isValidTile(tile: Vector2i) -> bool:
	var isreachable : bool = isReachable(tile)
	var hasobstacles : bool = hasObstacles(tile)
	
	if isreachable and not hasobstacles:
		return true
	return false
	
func isReachable(tile : Vector2i) -> bool:
	var data_lines = lines.get_cell_tile_data(tile)
	var data_ground = ground.get_cell_tile_data(tile)
	if data_lines:
		if data_lines.get_custom_data(is_walkable):
			return true
		return false
	if data_ground:
		if data_ground.get_custom_data(is_walkable):
			return true
	return false
	
func hasObstacles(tile : Vector2i):
	var data_obstacles = obstacles.get_cell_tile_data(tile)
	if data_obstacles:
		return true
	return false
