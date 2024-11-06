class_name Gridlines extends TileMapLayer

@onready var map: Map = $".."
@export var cell_size = Vector2(64, 64)
@export var cells : PackedVector2Array
var grid_size

func _process(_delta):
	pass
	#queue_redraw()

func _ready():
	initialize_grid()
	

func initialize_grid():
	grid_size = Vector2i(get_viewport_rect().size)
	draw_center()

func _draw():
	draw_grid()
	#draw_rect(Rect2(Vector2(0,1) * cell_size, cell_size), Color.GREEN_YELLOW)
	#draw_squares()
	draw_center()

func draw_grid():
	for x in grid_size.x + 1:
		draw_line(Vector2(x * cell_size.x, 0),
			Vector2(x * cell_size.x, grid_size.y * cell_size.y),
			Color.DARK_GRAY, 1.0)
	for y in grid_size.y + 1:
		draw_line(Vector2(0, y * cell_size.y),
			Vector2(grid_size.x * cell_size.x, y * cell_size.y),
			Color.DARK_GRAY, 1.0)
		
func draw_center():
	print("asafafa")
	for x in range(20):
		for y in range(20):
			if x == x and y == y:
				var center_position = Vector2(x * cell_size.x + cell_size.x / 2, y * cell_size.y + cell_size.y / 2)
				#var is_valid = map.isValidTile(Vector2i(x, y))
				var color = Color.BLACK
				draw_circle(center_position, 2.0, color)
			
func draw_squares():
	for cell in cells:
		draw_rect(Rect2(cell * cell_size, cell_size), Color.GREEN_YELLOW)
		

func clear_squares():
	cells = []
