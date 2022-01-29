extends Control

func _ready():
	pass

	
func _process(delta):
	if get_global_mouse_position().x<859:
		GameStatus.left_screen = true
	else:
		GameStatus.left_screen = false	
