extends Node

var finish = [false,false]

var move = [false,false]

var died = [false,false]
var left_screen = true

var rats_ref = {
	0: null,
	1: null
}

func set_died():
	for rat in rats_ref:
		rats_ref[rat].reset()

func _ready():
	pass
