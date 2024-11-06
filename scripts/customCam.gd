class_name customCam extends Camera2D

var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
var tilesize = 64

func _unhandled_input(event: InputEvent) -> void:
	for dir in inputs.keys():
			if event.is_action_pressed(dir):
				move(dir)
		
func move(dir):
	position = position + inputs[dir] * tilesize
