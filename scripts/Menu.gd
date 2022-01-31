extends Control


onready var sounds = [
	"res://assets/sfx/menusfx/klik1.wav",
	"res://assets/sfx/menusfx/klik2.wav",
	"res://assets/sfx/menusfx/klik3.wav",
	"res://assets/sfx/menusfx/klik4.wav",
	"res://assets/sfx/menusfx/klik5.wav"
]

func play_sound():
	$"AudioStreamPlayer".stream = load(sounds[randi() % 5])
	$"AudioStreamPlayer".play()


func _on_Credits_pressed():
	$"Main".hide()
	$"CreditsView".show()
	play_sound()

func _on_Back_to_menu_pressed():
	$"CreditsView".hide()
	$"Main".show()
	play_sound()

func _on_Settings_pressed():
	$"Main".hide()
	$"SettingsView".show()
	play_sound()

func _on_SettingsBack_to_menu_pressed():
	$"SettingsView".hide()
	$"Main".show()
	play_sound()

func _ready():

	randomize()
	$"Sprite/AnimationPlayer".play("planet_rot")
	AudioServer.set_bus_volume_db(1, linear2db(GameStatus.music))
	AudioServer.set_bus_volume_db(2, linear2db(GameStatus.audio))
	$SettingsView/musicslider.value = GameStatus.music
	$SettingsView/sfxslider.value = GameStatus.audio
	
	if !GameStatus.fullscreen:
		OS.window_fullscreen = GameStatus.fullscreen
		yield(get_tree().create_timer(0.5), "timeout")
		OS.set_window_size(OS.get_screen_size()-Vector2(50,50))

func _on_Quit_pressed():
	play_sound()
	get_tree().quit()


func _on_Play_pressed():
	get_parent().to_maps()
	play_sound()


func _on_sfxslider_value_changed(value):
	GameStatus.audio = value
	AudioServer.set_bus_volume_db(2, linear2db(value))
	GameStatus.save()
	


func _on_musicslider_value_changed(value):
	GameStatus.music = value
	AudioServer.set_bus_volume_db(1, linear2db(value))
	GameStatus.save()


func _on_CheckBox_toggled(button_pressed):
	OS.window_fullscreen = !OS.window_fullscreen
	if !OS.window_fullscreen:
		OS.set_window_size(OS.get_screen_size()-Vector2(50,50))
	GameStatus.fullscreen = OS.window_fullscreen
	GameStatus.save()
