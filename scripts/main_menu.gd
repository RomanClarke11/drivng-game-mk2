extends Control
var hiden = false
func _ready():
	%buttons.visible = true
	%"roman label".visible = false
func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/level_menu.tscn")




func _on_settings_pressed():
	print("SETTINGS")


func _on_quit_pressed():
	get_tree().quit()


func _on_button_pressed():
	if hiden == false:
		%buttons.visible = false
		%"roman label".visible = true
		hiden = true
	elif hiden == true:
		%buttons.visible = true
		%"roman label".visible = false
		hiden = false
