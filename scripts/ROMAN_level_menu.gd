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


func _on_four_pressed():
	%ColorRect.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/levels by roma/giving_way_scene_4.tscn")


func _on_five_pressed():
	%ColorRect.visible = true
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/levels by roma/giving_way_scene_5.tscn")
