extends Node2D

onready var wall_scene = preload("res://objects/Sciana.tscn")
onready var small_ob = preload("res://objects/Small_Obj.tscn")
onready var big_obj = preload("res://objects/Obj_big.tscn")

export var biom_id = 1

onready var tilemap = $"TileMap"





func _ready():		
	for cell in tilemap.get_used_cells_by_id(1):
		tilemap.set_cell(cell.x, cell.y, -1)
		
		var wall = wall_scene.instance()
		wall.position = tilemap.map_to_world(cell)
		$"Walls".add_child(wall)
	for cell in tilemap.get_used_cells_by_id(2):
		tilemap.set_cell(cell.x, cell.y, -1)
		
		var sb = small_ob.instance()
		sb.position = tilemap.map_to_world(cell)
		$"Walls".add_child(sb)
	for cell in tilemap.get_used_cells_by_id(3):
		tilemap.set_cell(cell.x, cell.y, -1)
		
		var bob = big_obj.instance()
		bob.position = tilemap.map_to_world(cell)
		$"Walls".add_child(bob)	
