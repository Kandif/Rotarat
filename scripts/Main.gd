extends Node2D

var status = "nothing"

var games = [
	[preload("res://scenes/maps/map0.tscn"),preload("res://scenes/maps/map01.tscn"),"1"],
	[preload("res://scenes/maps/map11.tscn"),preload("res://scenes/maps/map12.tscn"),"2"],
	[preload("res://scenes/maps/map21.tscn"),preload("res://scenes/maps/map22.tscn"),"1"],
]

var actual_world = "menu"

var old_song = ""

var stage_id = 1

func _ready():
	GameStatus.main_ref = self
	$musics/menu.play()
	
func to_maps():
	$Tween.interpolate_property($maps,"modulate",Color(1,1,1,0),Color(1,1,1,1),2)
	$Tween.start()
	
func to_menu():
	pass

func to_game(id):
	stage_id = id
	$"Game_Base/HBoxContainer/l-asp/left/Viewport".add_child((games[id-1][0]).instance())
	$"Game_Base/HBoxContainer/r-asp/right/Viewport".add_child((games[id-1][1]).instance())
	$Game_Base.visible=true
	$Game_Base.set_biom(int(games[id-1][2]))
	status = "to_game"
	$Tween.interpolate_property($musics.get_node(actual_world),"volume_db",0,-80,1)
	$Tween.interpolate_property($musics.get_node("biom"+games[id-1][2]),"volume_db",-80,0,1)
	$Tween.interpolate_property($maps,"modulate",Color(1,1,1,1),Color(1,1,1,0),2)
	$Tween.interpolate_property($Game_Base,"modulate",Color(1,1,1,0),Color(1,1,1,1),2)
	$Tween.start()
	old_song = actual_world 
	actual_world = "biom"+games[id-1][2]
	$musics.get_node("biom"+games[id-1][2]).play()

func finish_stage():
	status = "back_to_maps"
	$Tween.interpolate_property($maps,"modulate",Color(1,1,1,0),Color(1,1,1,1),2)
	$Tween.interpolate_property($Game_Base,"modulate",Color(1,1,1,1),Color(1,1,1,0),2)
	$Tween.start()
	$maps.succed(stage_id)
	GameStatus.maps[stage_id-1] = true
	GameStatus.save()


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
			$musics.get_node(old_song).stop()
			
