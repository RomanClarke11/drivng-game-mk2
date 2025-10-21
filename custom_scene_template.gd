extends Node3D

@onready var game_over: Control = %gameOver

signal _on_any_area_body_entered

func _ready():
	for area in get_tree().get_nodes_in_group("Traffic_triggers"):
		area.body_entered.connect(_on_any_area_body_entered.bind(area))


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == $car:
		get_tree().paused = true


func _on_car_body_entered(body: Node) -> void:
	get_tree().paused = true
	game_over.show()

func _on_button_pressed() -> void:
	get_tree().quit()
	

func _on_button_2_pressed() -> void:
	get_tree().reload_current_scene()
	game_over.hide()
