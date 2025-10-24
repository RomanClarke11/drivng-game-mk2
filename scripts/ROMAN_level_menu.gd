extends Control


func _ready():
	%ColorRect.visible = false


func _on_one_pressed():
	%ColorRect.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/levels by roma/giving_way_scene_1.tscn")

func _on_two_button_up():
	%ColorRect.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/levels by roma/giving_way_scene_2.tscn")


func _on_three_pressed():
	%ColorRect.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/levels by roma/giving_way_scene_3.tscn")

#these two button names are wrong so wswitched them 
func _on_four_pressed():
	%ColorRect.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/levels by roma/giving_way_scene_5.tscn")


func _on_five_pressed():
	%ColorRect.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/levels by roma/giving_way_scene_4.tscn")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_lvl_2_pressed() -> void:
	%ColorRect.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/level_menu2.tscn")


func _on_six_pressed() -> void:
	%ColorRect.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://CustomSceneTemplate.tscn")


func _on_back_pressed() -> void:
	%ColorRect.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/level_menu.tscn")
