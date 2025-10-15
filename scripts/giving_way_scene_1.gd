extends Node3D
var isDead = false
var radioOpen = false

func _ready():
	%radio.visible = false

func _process(delta):
	if isDead:
		%gameOver.visible = true
		%"explosion sfxx".play()
		get_tree().paused = true

	if Input.is_action_just_pressed("r"):
		if radioOpen == true:
			get_tree().paused = false
			%radio.visible = false
			radioOpen = false
		else:
			get_tree().paused = true
			%radio.visible = true
			radioOpen = true

func _on_area_3d_area_entered(area):
	if area.has_method("isCar"):
		isDead = true

func _on_area_3d_2_area_entered(area):
	if area.has_method("isCar"):
		isDead = true

func _on_area_3d_3_area_entered(area):
	if area.has_method("isCar"):
		isDead = true
	
func _on_area_3d_4_area_entered(area):
	if area.has_method("isCar"):
		isDead = true

func _on_button_2_pressed():
	isDead = false
	%gameOver.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_enemy_car_area_entered(area):
	if area.has_method("isCar"):
		isDead = true

func _on_quit_button_pressed():
	get_tree().paused = false
	%radio.visible = false
	radioOpen = false


func _on_win_area_area_entered(area):
	if area.has_method("isCar"):
		print("win")
