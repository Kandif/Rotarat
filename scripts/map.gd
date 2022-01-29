extends Node2D


var win = preload("res://assets/graphics/objects/icon_map_past.png")
var nonwin = preload("res://assets/graphics/objects/icon_map_future.png")
var disabled = preload("res://assets/graphics/objects/icon_map_grey.png")

var disabled_map=true


func _ready():
	$IconMapFuture.texture = disabled
	pass # Replace with function body.

func succed():
	$IconMapFuture.texture = win
	disabled_map=false
	
func unlock():
	disabled_map=false
	$IconMapFuture.texture = nonwin
