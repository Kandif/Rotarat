extends Node

var finish = [false,false]

var move = [false,false]

var died = [false,false]
var left_screen = true

var maps = [false,false,false,false,false,false,false,false,false,false,false,false]

var audio = 0.5
var music = 0.5
var fullscreen = true

func save():
	var file = File.new()
	var dir = Directory.new()
	if !dir.dir_exists("user://"):
		dir.make_dir("user://")
	file.open_encrypted_with_pass("user://save.save", File.WRITE,"zyciezyciejestnowala")
	var save_json = to_json({
		"audio" : audio,
		"music" : music,
		"maps" : maps,
		"fullscreen" : fullscreen
	})
	file.store_string(save_json)
	file.close()

func _ready():
	var file = File.new()
	if file.file_exists("user://save.save"):
		file.open_encrypted_with_pass("user://save.save", File.READ,"zyciezyciejestnowala")
		var all = parse_json(file.get_as_text())
		audio = all.audio
		music = all.music
		maps = all.maps
		if all.has("fullscreen"):
			fullscreen = all.fullscreen
		else:
			fullscreen = true
		
func moving():
	return (move[0] || move[1])

var rats_ref = {
	0: null,
	1: null
}

func focus_butt(is_left,butt,is_b):
	var bname = "right" if butt.name=="left" else "left" if butt.name=="right" else "down" if butt.name=="up" else "up"
	if is_left:
		rats_ref[1].focus_d(bname,is_b)
	else:
		rats_ref[0].focus_d(bname,is_b)
		
var main_ref = null

func set_died():
	for rat in rats_ref:
		rats_ref[rat].reset()

func set_test():
	if main_ref!=null && finish[0] && finish[1]:
		main_ref.finish_stage()
		
func to_maps():
	main_ref.to_maps_game()	
		
func to_menu():
	main_ref.to_menu()		
		
func intro():
	main_ref.intro()		
		
func outro():
	main_ref.outro()		
						
		

