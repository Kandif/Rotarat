extends Node2D

var status = "nothing"

var games = [
	[preload("res://scenes/maps/map0.tscn"),preload("res://scenes/maps/map01.tscn"),"1"],
	[preload("res://scenes/maps/map81.tscn"),preload("res://scenes/maps/map82.tscn"),"1"],
	[preload("res://scenes/maps/map41.tscn"),preload("res://scenes/maps/map42.tscn"),"2"],
	[preload("res://scenes/maps/map31.tscn"),preload("res://scenes/maps/map32.tscn"),"2"],
	[preload("res://scenes/maps/map11.tscn"),preload("res://scenes/maps/map12.tscn"),"3"],
	[preload("res://scenes/maps/map121.tscn"),preload("res://scenes/maps/map122.tscn"),"3"],
	[preload("res://scenes/maps/map51.tscn"),preload("res://scenes/maps/map52.tscn"),"4"],
	[preload("res://scenes/maps/map21.tscn"),preload("res://scenes/maps/map22.tscn"),"4"]	
]

var intro = preload("res://assets/video/intro.webm")
var outro = preload("res://assets/video/outro.webm")

var actual_world = "menu"

var old_song = ""

var stage_id = 1

var first = true

func _ready():
	GameStatus.main_ref = self
	$musics/menu.play()
	
func to_maps():
	if !GameStatus.maps[0] && first:
		intro()
		first = false
		$Tween.interpolate_property($into,"modulate",Color(1,1,1,0),Color(1,1,1,1),2)
		$Tween.start()
	else:	
		$Tween.interpolate_property($maps,"modulate",Color(1,1,1,0),Color(1,1,1,1),1)
		$Tween.start()
	

func to_game(id):
	if id==1:
		$Game_Base.set_tutorial()
	stage_id = id
	$"Game_Base/HBoxContainer/l-asp/left/Viewport".add_child((games[id-1][0]).instance())
	$"Game_Base/HBoxContainer/r-asp/right/Viewport".add_child((games[id-1][1]).instance())
	$Game_Base.visible=true
	$Game_Base.set_biom(int(games[id-1][2]))
	status = "to_game"
	if !$musics.get_node("biom"+games[id-1][2]).playing:
		$Tween.interpolate_property($musics.get_node(actual_world),"volume_db",0,-80,1)
		$Tween.interpolate_property($musics.get_node("biom"+games[id-1][2]),"volume_db",-80,0,1)
		old_song = actual_world 
		actual_world = "biom"+games[id-1][2]
		$musics.get_node("biom"+games[id-1][2]).play()
	$Tween.interpolate_property($maps,"modulate",Color(1,1,1,1),Color(1,1,1,0),2)
	$Tween.interpolate_property($Game_Base,"modulate",Color(1,1,1,0),Color(1,1,1,1),2)
	$Tween.start()
	

func finish_stage():
	if stage_id ==8:
		outro()
		$Tween.interpolate_property($maps,"modulate",Color(1,1,1,0),Color(1,1,1,1),2)
		$Tween.interpolate_property($Game_Base,"modulate",Color(1,1,1,1),Color(1,1,1,0),2)
		$Tween.start()
		$maps.succed(stage_id)
		GameStatus.maps[stage_id-1] = true
		GameStatus.save()
		$maps/outro.disabled=false
	else:	
		status = "back_to_maps"
		$maps.visible=true
		$Tween.interpolate_property($maps,"modulate",Color(1,1,1,0),Color(1,1,1,1),2)
		$Tween.interpolate_property($Game_Base,"modulate",Color(1,1,1,1),Color(1,1,1,0),2)
		$Tween.start()
		$maps.succed(stage_id)
		GameStatus.maps[stage_id-1] = true
		GameStatus.save()
	
func to_maps_game():
	status = "back_to_maps"
	$maps.visible=true
	$Tween.interpolate_property($maps,"modulate",Color(1,1,1,0),Color(1,1,1,1),2)
	$Tween.interpolate_property($Game_Base,"modulate",Color(1,1,1,1),Color(1,1,1,0),2)
	$Tween.start()

func to_menu():
	$Tween.interpolate_property($maps,"modulate",Color(1,1,1,1),Color(1,1,1,0),2)
	$Tween.start()

func _on_Tween_tween_all_completed():
	match(status):
		"nothing":
			pass
		"back_to_maps":
			$"Game_Base/HBoxContainer/l-asp/left/Viewport".remove_child($"Game_Base/HBoxContainer/l-asp/left/Viewport".get_child(0))
			$"Game_Base/HBoxContainer/r-asp/right/Viewport".remove_child($"Game_Base/HBoxContainer/r-asp/right/Viewport".get_child(0))
			$Game_Base.visible=false
			status="nothing"
		"to_game":
			$maps.visible = false
			$musics.get_node(old_song).stop()
			
func intro():
	$into.visible = true
	$Tween.interpolate_property($musics.get_node(actual_world),"volume_db",0,-80,1)
	$Tween.interpolate_property($into,"modulate",Color(1,1,1,0),Color(1,1,1,1),1)
	$Tween.start()
	$into/VideoPlayer.stream = intro
	$into/VideoPlayer.play()
	
func outro():
	$into.visible = true
	$Tween.interpolate_property($musics.get_node(actual_world),"volume_db",0,-80,1)
	$Tween.interpolate_property($into,"modulate",Color(1,1,1,0),Color(1,1,1,1),1)
	$Tween.start()
	$into/VideoPlayer.stream = outro
	$into/VideoPlayer.play()
		

func _on_VideoPlayer_finished():
	$Tween.interpolate_property($musics.get_node(actual_world),"volume_db",-80,0,1)
	$Tween.interpolate_property($into,"modulate",Color(1,1,1,1),Color(1,1,1,0),2)
	$into.visible = false
	$Tween.start()

