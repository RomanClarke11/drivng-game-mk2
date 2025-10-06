extends Node3D
var isDead = false


func _process(delta):
	if isDead:
		%gameOver.visible = true
		get_tree().paused = true
	
func _on_area_3d_area_entered(area):
	isDead = true


func _on_area_3d_2_area_entered(area):
	isDead = true


func _on_area_3d_3_area_entered(area):
	isDead = true
	
func _on_area_3d_4_area_entered(area):
	isDead = true


func _on_button_2_pressed():
	isDead = false
	%gameOver.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_enemy_car_area_entered(area):
	isDead = true
