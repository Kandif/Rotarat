extends Control



func _on_Credits_pressed():
	$"Main".hide()
	$"CreditsView".show()



func _on_Back_to_menu_pressed():
	$"CreditsView".hide()
	$"Main".show()



func _on_Settings_pressed():
	$"Main".hide()
	$"SettingsView".show()



func _on_SettingsBack_to_menu_pressed():
	$"SettingsView".hide()
	$"Main".show()

func _ready():
	$"Sprite/AnimationPlayer".play("planet_rot")
	AudioServer.set_bus_volume_db(1, linear2db(GameStatus.music))
	AudioServer.set_bus_volume_db(2, linear2db(GameStatus.audio))
	$SettingsView/musicslider.value = GameStatus.music
	$SettingsView/sfxslider.value = GameStatus.audio

func _on_Quit_pressed():
	get_tree().quit()


func _on_Play_pressed():
	get_parent().to_maps()
	pass # Replace with function body.


func _on_sfxslider_value_changed(value):
	GameStatus.audio = value
	AudioServer.set_bus_volume_db(2, linear2db(value))
	GameStatus.save()
	pass # Replace with function body.


func _on_musicslider_value_changed(value):
	GameStatus.music = value
	AudioServer.set_bus_volume_db(1, linear2db(value))
	GameStatus.save()
	pass # Replace with function body.
