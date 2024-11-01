extends TileMapLayer

@onready var ground: TileMapLayer = $Ground
@onready var lines: TileMapLayer = $Lines
@onready var elements: TileMapLayer = $Elements
@onready var net: TileMapLayer = $Net


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_backspace"):
		var mouse_global : Vector2 = get_global_mouse_position()
		var map_mouse_to_loc : Vector2 = ground.local_to_map(mouse_global)
		var list = ground.get_surrounding_cells(map_mouse_to_loc)
		for i in list:
			ground.erase_cell(i)
		
	
