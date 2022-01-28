extends Node2D

export var left_side = true

var fix = 1
var player_id = 1
onready var camera = $cam
onready var player = $Player

var ray = {}

func _ready():
	print($"../TileMap".get_cell(13, 8))
	print($"../TileMap".get_cell(15, 8))



	$Player/ref_l.visible = false
	$Player/ref_r.visible = false
	if left_side:
		fix = -1
		$Player/Sprite.position.x -= 285
		$Player/CollisionShape2D.position.x -= 285
		$"Player/action-colision".position.x -= 285
		ray = {
			"left" : get_node("Player/action-colision/left"),
			"right" : get_node("Player/action-colision/right"),
			"up" : get_node("Player/action-colision/up"),
			"down" : get_node("Player/action-colision/down")
		}
	else:
		player_id = 2
		fix = 1
		$Player/Sprite.position.x += 285
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



#	print(ray.left.is_colliding())
	if event.is_pressed() && event is InputEventMouseButton && event.button_index == (player_id) && !$Tween.is_active():
		$Tween.interpolate_property(camera,"rotation_degrees",camera.rotation_degrees,camera.rotation_degrees+90,0.5)
		$Tween.interpolate_property(player,"rotation_degrees",player.rotation_degrees,player.rotation_degrees+90,0.5)
		$Player/CollisionShape2D.disabled = true
		$Tween.start()

	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_UP && !$Tween.is_active() && !ray.up.is_colliding():
		$Tween.interpolate_property(player,"position",player.position,player.position+Vector2(0, fix*95).rotated(player.rotation),0.5)
		$Tween.start()
	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_LEFT && !$Tween.is_active() && !ray.left.is_colliding():
		$Tween.interpolate_property(player,"position",player.position,player.position+Vector2(fix*95, 0).rotated(player.rotation),0.5)
		$Tween.start()
	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_RIGHT && !$Tween.is_active() && !ray.right.is_colliding():
		$Tween.interpolate_property(player,"position",player.position,player.position+Vector2(-fix*95, 0).rotated(player.rotation),0.5)
		$Tween.start()
	if event.is_pressed() && (event is InputEventKey) && event.scancode == KEY_DOWN && !$Tween.is_active() && !ray.down.is_colliding():
		$Tween.interpolate_property(player,"position",player.position,player.position+Vector2(0, -fix*95).rotated(player.rotation),0.5)
		$Tween.start()


func _on_Tween_tween_all_completed():
	$Player/CollisionShape2D.disabled = false
	GameStatus.move[player_id-1] = false
	pass # Replace with function body.


func _on_actioncolision_area_entered(area):
	if area.is_in_group("finish"):
		GameStatus.finish[player_id-1] = true


func _on_actioncolision_area_exited(area):
	if area.is_in_group("finish"):
		GameStatus.finish[player_id-1] = false


func _on_Tween_tween_started(object, key):
	GameStatus.move[player_id-1] = false
