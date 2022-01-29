extends Control

func _ready():
	pass
	
var bioms_frames= [
	preload("res://assets/graphics/mountain_world/background.png"),
	preload("res://assets/graphics/backgrounds/waterland.png"),
	preload("res://assets/graphics/backgrounds/ccandy.png"),
	preload("res://assets/graphics/backgrounds/crystals_framebg.png")
]
	
func _process(delta):
	if get_global_mouse_position().x<859:
		GameStatus.left_screen = true
	else:
		GameStatus.left_screen = false
	
func set_biom(biom):
	match(biom):
		1:
			$TextureRect.texture = bioms_frames[0]
		2:
			$TextureRect.texture = bioms_frames[1]
		3:
			$TextureRect.texture = bioms_frames[2]
		4:			
			$TextureRect.texture = bioms_frames[3]
