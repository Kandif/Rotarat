extends Node2D

onready var wall_scene = preload("res://objects/Sciana.tscn")
onready var small_obj = preload("res://objects/Small_Obj.tscn")
onready var big_obj = preload("res://objects/Obj_big.tscn")


#onready var no_obj = preload("res://assets/graphics/NO_OBJ_PLACEHOLDER.png")

onready var water_tilset = preload("res://assets/graphics/water_world/water.png")


onready var candy_tileset = preload("res://assets/graphics/candy_world/tileset_candy/tileset_candy.png")


onready var crystal_tileset = preload("res://assets/graphics/crystal_world/tileset_crystal/tileset_crystal.png")


onready var walls = ["res://assets/graphics/water_world/1.png", "res://assets/graphics/candy_world/2.png", "res://assets/graphics/crystal_world/3.png"]
onready var small_objects = ["res://assets/graphics/water_world/s_ob_1.png", "res://assets/graphics/NO_OBJ_PLACEHOLDER.png", "res://assets/graphics/crystal_world/s_ob_3.png"]
onready var backgrounds = ["res://assets/graphics/water_world/bg_1.png", "res://assets/graphics/candy_world/bg_2.png", "res://assets/graphics/crystal_world/bg_3.png"]



export var biom_id = 1

onready var tilemap = $"TileMap"




func _ready():

	for cell in tilemap.get_used_cells_by_id(1):
		tilemap.set_cell(cell.x, cell.y, -1)

		var wall = wall_scene.instance()
		wall.position = tilemap.map_to_world(cell)
		$"Walls".add_child(wall)

		if biom_id != 0:
			wall.get_node("Sprite").texture = load(walls[biom_id - 1])
			$"CanvasLayer/MountBg2".texture = load(backgrounds[biom_id - 1])





	for cell in tilemap.get_used_cells_by_id(3):
		tilemap.set_cell(cell.x, cell.y, -1)

		var s_ob = small_obj.instance()
		s_ob.position = tilemap.map_to_world(cell)
		$"Walls".add_child(s_ob)

		if biom_id != 0:
			s_ob.texture = load(small_objects[biom_id - 1])
			$"CanvasLayer/MountBg2".texture = load(backgrounds[biom_id - 1])




	for cell in tilemap.get_used_cells_by_id(2):
		tilemap.set_cell(cell.x, cell.y, -1)

		var b_ob = big_obj.instance()
		b_ob.position = tilemap.map_to_world(cell)
		$"Walls".add_child(b_ob)

		if biom_id != 0:
			b_ob.animation = "biom_" + str(biom_id)
			$"CanvasLayer/MountBg2".texture = load(backgrounds[biom_id - 1])




#0 = gory, 1 = woda, 2 cukierki, 3 krysztaly


	match biom_id:
		0:
			return

		1:
			$"TileMap".tile_set.tile_set_texture(0, water_tilset)


		2:
			$"TileMap".tile_set.tile_set_texture(0, candy_tileset)


		3:
			$"TileMap".tile_set.tile_set_texture(0, crystal_tileset)


