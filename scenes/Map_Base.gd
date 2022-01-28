extends Node2D

onready var wall_scene = preload("res://objects/Sciana.tscn")

onready var tilemap = $"TileMap"





func _ready():		
	for cell in tilemap.get_used_cells_by_id(1):
		tilemap.set_cell(cell.x, cell.y, -1)
		
		var wall = wall_scene.instance()
		wall.position = tilemap.map_to_world(cell)
		$"Walls".add_child(wall)
