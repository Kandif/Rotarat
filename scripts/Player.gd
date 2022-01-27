extends KinematicBody2D

var velocity = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func _process(delta):
	velocity = move_and_slide(velocity)
