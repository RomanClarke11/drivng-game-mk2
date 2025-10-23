extends Node3D

@onready var game_over: Control = %gameOver
@onready var objective_text: Control = $"Objective Text"

func _ready():
	for area in get_tree().get_nodes_in_group("Traffic_triggers"):
		area.body_entered.connect(Callable(self, "_on_any_area_body_entered").bind(area))
	
	get_tree().paused = true
	objective_text.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _on_any_area_body_entered(body, area) -> void:
	if body == $car:
		%gameOver.visible = true
		%"explosion sfxx".play()
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	#pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == $car:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _on_car_body_entered(body: Node) -> void:
	get_tree().paused = true
	game_over.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_button_pressed() -> void:
	get_tree().quit()
	

func _on_button_2_pressed() -> void:
	get_tree().reload_current_scene()
	game_over.hide()


func _on_begin_pressed() -> void:
	objective_text.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
