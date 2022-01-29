extends Node2D


func _ready():
	for map in $maps1.get_children():
		map.connect("mouse_entered",self,"focus",[map])
	for map in $maps2.get_children():
		map.connect("mouse_entered",self,"focus",[map])

func focus(map):
	if map.get_parent().name == "maps1":
		$rat1.rotation_degrees = map.rect_rotation
		$rat1.global_position = map.rect_global_position+Vector2(60,-50).rotated($rat1.rotation)
		$rat2.rotation_degrees = $maps2.get_node(map.name).rect_rotation
		$rat2.global_position = $maps2.get_node(map.name).rect_global_position+Vector2(60,-50).rotated($rat2.rotation)
		
	if map.get_parent().name == "maps2":
		$rat2.rotation_degrees = map.rect_rotation
		$rat2.global_position = map.rect_global_position+Vector2(60,-50).rotated($rat2.rotation)
		$rat1.rotation_degrees = $maps1.get_node(map.name).rect_rotation
		$rat1.global_position = $maps1.get_node(map.name).rect_global_position+Vector2(60,-50).rotated($rat1.rotation)
