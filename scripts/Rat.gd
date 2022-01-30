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
#	if !left_side:
#		$Player/butts/down.set_normal_texture(preload("res://assets/graphics/UI/gora.png"))  
#		$Player/butts/up.set_normal_texture(preload("res://assets/graphics/UI/dol.png"))  
#		$Player/butts/left.set_normal_texture(preload("res://assets/graphics/UI/prawo.png"))  
#		$Player/butts/right.set_normal_texture(preload("res://assets/graphics/UI/lewo.png"))  
#
#	for butt in $Player/butts.get_children():
#		butt.connect("pressed",self,"butt_press",[butt])
#		butt.connect("mouse_entered",self,"focus",[butt,true])
#		butt.connect("mouse_exited",self,"focus",[butt,false])
	
	start_position = player.global_position
	if left_side:
#		$Player/butts/down.rect_position.x -= 285
#		$Player/butts/up.rect_position.x -= 285 
#		$Player/butts/left.rect_position.x -= 285
#		$Player/butts/right.rect_position.x -= 285
		$Player/anmt.animation = "right"
		GameStatus.rats_ref[0] = self
		$Player/ref_l.position = player.position + Vector2(0,285)
		$Player/ref_r.position = player.position + Vector2(0,-285)
		fix = -1
		$Player/anmt.position.x -= 285
		$Player/CollisionShape2D.position.x -= 285
		$"Player/action-colision".position.x -= 285
		ray = {
			"left" : get_node("Player/action-colision/left"),
			"right" : get_node("Player/action-colision/right"),
			"up" : get_node("Player/action-colision/up"),
			"down" : get_node("Player/action-colision/down")
		}
	else:	
#		$Player/butts/down.rect_position.x += 285
#		$Player/butts/up.rect_position.x += 285 
#		$Player/butts/left.rect_position.x += 285
#		$Player/butts/right.rect_position.x += 285
		$Player/anmt.animation = "left"
		GameStatus.rats_ref[1] = self
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
		
func butt_press(butt):
	var bname = butt.name
	if !left_side:
		bname = "right" if butt.name=="left" else "left" if butt.name=="right" else "down" if butt.name=="up" else "up"
	match(bname):
		"left":
			var ev =  InputEventKey.new()
			ev.pressed = true
			ev.scancode = KEY_A
			Input.parse_input_event(ev)	
		"right":
			var ev =  InputEventKey.new()
			ev.pressed = true
			ev.scancode = KEY_D
			Input.parse_input_event(ev)	
		"up":
			var ev =  InputEventKey.new()
			ev.pressed = true
			ev.scancode = KEY_W
			Input.parse_input_event(ev)	
		"down":
			var ev =  InputEventKey.new()
			ev.pressed = true
			ev.scancode = KEY_S
			Input.parse_input_event(ev)			
	pass
	
func focus(butt,is_b):
	if is_b:
		butt.modulate= Color(1,1,1,1)
		GameStatus.focus_butt(left_side,butt,is_b)
	else:
		butt.modulate= Color(1,1,1,0.5)	
		GameStatus.focus_butt(left_side,butt,is_b)

func focus_d(bname,is_b):
	if is_b:
		$Player/butts.get_node(bname).modulate= Color(1,1,1,1)
	else:
		$Player/butts.get_node(bname).modulate= Color(1,1,1,0.5)	


func _process(delta):
	$cam.position = $Player.position


func _input(event):
	
	if Input.is_action_just_pressed("ui_accept") && get_parent().get_parent().has_node("bgg"):
		get_node("../../bgg/BG").visible = false
	
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
	
	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_W && !$Tween.is_active() && !ray.up.is_colliding() && !GameStatus.moving():
		if status=="glue":
			status="normal"
		else:	
			go_up()
	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_A && !$Tween.is_active() && !ray.left.is_colliding() && !GameStatus.moving():
		if status=="glue":
			status="normal"
		else:	
			go_left()
	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_D && !$Tween.is_active() && !ray.right.is_colliding() && !GameStatus.moving():	
		if status=="glue":
			status="normal"
		else:
			go_right()
	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_S && !$Tween.is_active() && !ray.down.is_colliding() && !GameStatus.moving():
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
			var vectorx = area.vect.rotated(player.rotation)*fix
			print(vectorx)
			print(player.rotation)
			if vectorx.x == -1:
				if !ray.left.is_colliding():
					go_left()
				else:
					GameStatus.move[player_id-1] = false	
			if vectorx.x == 1:
				if !ray.right.is_colliding():
					go_right()
				else:
					GameStatus.move[player_id-1] = false	
			if vectorx.y == -1:
				if !ray.up.is_colliding():
					go_up()
				else:
					GameStatus.move[player_id-1] = false	
			if vectorx.y == 1:
				if !ray.down.is_colliding():
					go_down()
				else:		
					GameStatus.move[player_id-1] = false
		elif area.is_in_group("glue"):
			status="glue"
		elif area.is_in_group("ice"):
			match($Player/anmt.animation):
				"up":
					if left_side && !ray.up.is_colliding():
						go_up()
					elif !left_side && !ray.down.is_colliding():
						go_down()
					else:
						GameStatus.move[player_id-1] = false
				"left":
					if left_side && !ray.left.is_colliding():
						go_left()
					elif !left_side && !ray.right.is_colliding():
						go_right()
					else:
						GameStatus.move[player_id-1] = false
				"down":
					if left_side && !ray.down.is_colliding():
						go_down()
					elif !left_side && !ray.up.is_colliding():
						go_up()
					else:
						GameStatus.move[player_id-1] = false
				"right":
					if left_side && !ray.right.is_colliding():
						go_right()
					elif !left_side && !ray.left.is_colliding():
						go_left()
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


