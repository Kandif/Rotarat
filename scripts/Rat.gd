extends Node2D

export var left_side = true

var fix = 1
var player_id = 1
onready var camera = $cam
onready var player = $Player

var zoom = 1

var start_position = Vector2.ZERO
var start_rotation = 0

var status = "normal"

onready var tiles:TileMap = $"../TileMap"

var dirc = [["left","right","up","down"],["right","left","down","up"]]

var move = false

enum DIRC { up,down,left,right }

var ray = {}

func _ready():
	start_position = player.global_position
	if left_side:
		$Player/anmt.animation = "right"
		GameStatus.rats_ref[0] = self
		$Player/ref_l.position = player.position + Vector2(0,285)
		$Player/ref_r.position = player.position + Vector2(0,-285)
		fix = -1
		$Player/anmt.position.x -= 285
		$Player/anmt.modulate = Color.pink
		$Player/CollisionShape2D.position.x -= 285
		$"Player/action-colision".position.x -= 285
		ray = {
			"left" : get_node("Player/action-colision/left"),
			"right" : get_node("Player/action-colision/right"),
			"up" : get_node("Player/action-colision/up"),
			"down" : get_node("Player/action-colision/down")
		}
	else:	
		$Player/anmt.animation = "left"
		GameStatus.rats_ref[1] = self
		$Player/anmt.modulate = Color.deepskyblue
		$Player/ref_l.position = player.position + Vector2(0,285)
		$Player/ref_r.position = player.position + Vector2(0,-285)
		player_id = 2
		fix = 1
		$Player/anmt.position.x += 285
		$Player/CollisionShape2D.position.x += 285
		$"Player/action-colision".position.x += 285
		ray = {
			"right" : get_node("Player/action-colision/left"),
			"left" : get_node("Player/action-colision/right"),
			"down" : get_node("Player/action-colision/up"),
			"up" : get_node("Player/action-colision/down")
		}

func _process(delta):
	$cam.position = $Player.position

func _input(event):
	
	if event.is_pressed() && event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_DOWN:
		zoom += 0.1
		if zoom >= 4.0:
			zoom = 4.0
		camera.zoom=Vector2(zoom,zoom)
		
	elif event.is_pressed() && event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_UP:	
		zoom -= 0.1
		if zoom <= 1.0:
			zoom = 1.0
		camera.zoom=Vector2(zoom,zoom)

	if event.is_pressed() && event is InputEventMouseButton && !$Tween.is_active() && GameStatus.left_screen==left_side && !GameStatus.moving():
		if event.button_index == (1):
			rotate_right()
		elif event.button_index == (2):	
			rotate_left()
	
	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_UP && !$Tween.is_active() && !ray.up.is_colliding() && !GameStatus.moving():
		if status=="glue":
			status="normal"
		else:	
			go_up()
	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_LEFT && !$Tween.is_active() && !ray.left.is_colliding() && !GameStatus.moving():
		if status=="glue":
			status="normal"
		else:	
			go_left()
	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_RIGHT && !$Tween.is_active() && !ray.right.is_colliding() && !GameStatus.moving():	
		if status=="glue":
			status="normal"
		else:
			go_right()
	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_DOWN && !$Tween.is_active() && !ray.down.is_colliding() && !GameStatus.moving():
		if status=="glue":
			status="normal"
		else:
			go_down()


func go_left():
	player.get_node("anmt").frame=0
	player.get_node("anmt").play(dirc[player_id-1][0])
	$Tween.interpolate_property(player,"position",player.position,player.position+Vector2(fix*95, 0).rotated(player.rotation),0.5)
	$Tween.start()
	
func go_right():
	player.get_node("anmt").frame=0
	player.get_node("anmt").play(dirc[player_id-1][1])
	$Tween.interpolate_property(player,"position",player.position,player.position+Vector2(-fix*95, 0).rotated(player.rotation),0.5)
	$Tween.start()	
	
func go_up():
	player.get_node("anmt").frame=0
	player.get_node("anmt").play(dirc[player_id-1][2])
	$Tween.interpolate_property(player,"position",player.position,player.position+Vector2(0, fix*95).rotated(player.rotation),0.5)
	$Tween.start()
	
func go_down():
	player.get_node("anmt").frame=0
	player.get_node("anmt").play(dirc[player_id-1][3])
	$Tween.interpolate_property(player,"position",player.position,player.position+Vector2(0, -fix*95).rotated(player.rotation),0.5)
	$Tween.start()
	
func rotate_left():
	player.get_node("anmt").frame=0
	$Tween.interpolate_property(camera,"rotation_degrees",camera.rotation_degrees,camera.rotation_degrees-90,0.5)
	$Tween.interpolate_property(player,"rotation_degrees",player.rotation_degrees,player.rotation_degrees-90,0.5)
	$Tween.interpolate_property(player.get_node("anmt"),"scale",player.get_node("anmt").scale,player.get_node("anmt").scale * Vector2(1.5,1.5),0.25)
	$Tween.interpolate_property(player.get_node("anmt"),"scale",player.get_node("anmt").scale * Vector2(1.5,1.5), player.get_node("anmt").scale, 0.25,Tween.EASE_IN,Tween.TRANS_LINEAR,0.25)
	for walls in get_node("../Walls").get_children():
		$Tween.interpolate_property(walls,"rotation_degrees",walls.rotation_degrees,walls.rotation_degrees-90,0.5)
	for walls in get_node("../Back_Objects").get_children():
		$Tween.interpolate_property(walls,"rotation_degrees",walls.rotation_degrees,walls.rotation_degrees-90,0.5)
	
	$Player/CollisionShape2D.disabled = true
	$Tween.start()
	
func rotate_right():
	player.get_node("anmt").frame=0
	$Tween.interpolate_property(camera,"rotation_degrees",camera.rotation_degrees,camera.rotation_degrees+90,0.5)
	$Tween.interpolate_property(player,"rotation_degrees",player.rotation_degrees,player.rotation_degrees+90,0.5)
	$Tween.interpolate_property(player.get_node("anmt"),"scale",player.get_node("anmt").scale,player.get_node("anmt").scale * Vector2(1.5,1.5),0.25)
	$Tween.interpolate_property(player.get_node("anmt"),"scale",player.get_node("anmt").scale * Vector2(1.5,1.5), player.get_node("anmt").scale, 0.25,Tween.EASE_IN,Tween.TRANS_LINEAR,0.25)
	for walls in get_node("../Walls").get_children():
		$Tween.interpolate_property(walls,"rotation_degrees",walls.rotation_degrees,walls.rotation_degrees+90,0.5)
	for walls in get_node("../Back_Objects").get_children():
		$Tween.interpolate_property(walls,"rotation_degrees",walls.rotation_degrees,walls.rotation_degrees+90,0.5)
	$Player/CollisionShape2D.disabled = true
	$Tween.start()	

func _on_Tween_tween_all_completed():
	$Player/CollisionShape2D.disabled = false
	
	var id_tile = tiles.get_cellv(tiles.world_to_map(tiles.to_local(player.get_node("anmt").global_position)))
	
	if id_tile == -1:
		GameStatus.set_died()
	GameStatus.set_test()
	GameStatus.move[player_id-1] = false
	for area in $"Player/action-colision".get_overlapping_areas():
		if area.is_in_group("wind"):
			GameStatus.move[player_id-1] = true
			match(area.direction):
				DIRC.left:
					if !ray.left.is_colliding():
						go_left()
					else:
						GameStatus.move[player_id-1] = false	
				DIRC.right:
					if !ray.right.is_colliding():
						go_right()
					else:
						GameStatus.move[player_id-1] = false	
				DIRC.up:
					if !ray.up.is_colliding():
						go_up()
					else:
						GameStatus.move[player_id-1] = false	
				DIRC.down:
					if !ray.down.is_colliding():
						go_down()		
					else:		
						GameStatus.move[player_id-1] = false
		elif area.is_in_group("glue"):
			status="glue"
		elif area.is_in_group("ice"):
			match($Player/anmt.animation):
				"up":
					if !ray.up.is_colliding():
						go_up()
					else:
						GameStatus.move[player_id-1] = false
				"left":
					if !ray.left.is_colliding():
						go_left()
					else:
						GameStatus.move[player_id-1] = false
				"down":
					if !ray.down.is_colliding():
						go_down()
					else:
						GameStatus.move[player_id-1] = false
				"right":
					if !ray.right.is_colliding():
						go_right()
					else:
						GameStatus.move[player_id-1] = false
					
			
	
	
func reset():
	$Tween.interpolate_property(player,"global_position",player.global_position,start_position,1)
	$Tween.interpolate_property(player,"rotation",player.rotation,0,1)
	$Tween.interpolate_property(camera,"rotation",camera.rotation,0,1)
	$Tween.start()
	for walls in get_node("../Walls").get_children():
		$Tween.interpolate_property(walls,"rotation_degrees",walls.rotation_degrees,0,0.5)
	for walls in get_node("../Back_Objects").get_children():
		$Tween.interpolate_property(walls,"rotation_degrees",walls.rotation_degrees,0,0.5)
#	player.global_position = start_position
#	player.rotation = 0
#	camera.rotation = 0

func _on_actioncolision_area_entered(area):
	if area.is_in_group("finish"):
		GameStatus.finish[player_id-1] = true
	if area.is_in_group("wind"):
		status="wind"


func _on_actioncolision_area_exited(area):
	if area.is_in_group("finish"):
		GameStatus.finish[player_id-1] = false
	if area.is_in_group("wind"):
		status="normal"


func _on_Tween_tween_started(object, key):
	if player.get_node("anmt").animation == "up":
		player.get_node("anmt").offset.y=250
		player.get_node("anmt").offset.x=-50
	else:
		player.get_node("anmt").offset.y=0
		player.get_node("anmt").offset.x=0
	GameStatus.move[player_id-1] = true
	move = true
