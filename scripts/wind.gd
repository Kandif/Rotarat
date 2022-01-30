extends Area2D


enum DIRC { up,down,left,right }
export(DIRC) var direction

var vect = Vector2.ZERO

func _ready():
	match(direction):
		DIRC.right:
			vect = Vector2(1,0)
		DIRC.left:
			vect = Vector2(-1,0)
			$AnimatedSprite.flip_h = true
		DIRC.down:
			vect = Vector2(0,1)
			$AnimatedSprite.rotation_degrees+=90
		DIRC.up:
			vect = Vector2(0,-1)
			$AnimatedSprite.rotation_degrees-=90			

