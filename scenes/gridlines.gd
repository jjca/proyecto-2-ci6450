extends TileMapLayer

@export var cell_size = Vector2(64, 64)
@export var cells : PackedVector2Array
var grid_size

func _process(_delta):
	queue_redraw()

func _ready():
	initialize_grid()

func initialize_grid():
	grid_size = Vector2i(get_viewport_rect().size)

func _draw():
	draw_grid()
	#draw_rect(Rect2(Vector2(0,1) * cell_size, cell_size), Color.GREEN_YELLOW)
	draw_squares()

func draw_grid():
	for x in grid_size.x + 1:
		draw_line(Vector2(x * cell_size.x, 0),
			Vector2(x * cell_size.x, grid_size.y * cell_size.y),
			Color.DARK_GRAY, 1.0)
	for y in grid_size.y + 1:
		draw_line(Vector2(0, y * cell_size.y),
			Vector2(grid_size.x * cell_size.x, y * cell_size.y),
			Color.DARK_GRAY, 1.0)
			
func draw_squares():
	for cell in cells:
		draw_rect(Rect2(cell * cell_size, cell_size), Color.GREEN_YELLOW)
