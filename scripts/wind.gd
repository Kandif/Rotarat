extends Area2D


enum DIRC { up,down,left,right }
export(DIRC) var direction = DIRC.right

func _ready():
	match(direction):
		DIRC.right:
			pass
		DIRC.left:
			$AnimatedSprite.flip_h = true
		DIRC.down:
			$AnimatedSprite.rotation_degrees+=90
		DIRC.up:
			$AnimatedSprite.rotation_degrees-=90			

