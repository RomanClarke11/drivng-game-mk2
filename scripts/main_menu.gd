extends Control


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/level_menu.tscn")




func _on_settings_pressed():
	print("SETTINGS")


func _on_quit_pressed():
	get_tree().quit()
