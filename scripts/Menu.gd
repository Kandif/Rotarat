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



func _on_Quit_pressed():
	get_tree().quit()
