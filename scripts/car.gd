extends VehicleBody3D

@export var MAX_steering = 0.3
@export var HORSE_power = 2000
@export var BREAK_power = 400
@onready var front_left_wheel = $"front left" 
@onready var front_right_wheel = $"front right"
@onready var rear_left_wheel = $"back left2"
@onready var rear_right_wheel = $"back left"
@onready var wheel = $"steering wheel"
var forward = false
var reversOrNot := true

func isCar():
	pass

func _input(event):
	if Input.is_action_just_pressed("q"):
		reversOrNot = !reversOrNot   # flip gear
		print("in reverse or not:", reversOrNot)

func _physics_process(delta):
	
	#turn w front wheels 
	var steering_input = Input.get_axis("a","d") * MAX_steering * -1
	var wheel_turn = Input.get_axis("a","d") / 75
	wheel.rotate_x(wheel_turn)
	steering = move_toward(steering, steering_input, delta * 2) 
	steering = clamp(steering, -MAX_steering, MAX_steering)
	front_left_wheel.steering = steering
	front_right_wheel.steering = steering
	
	#move with back wheels 
	var throttle := 0.0
	if Input.is_action_pressed("w"):
		if reversOrNot:
			throttle = HORSE_power
		else:
			throttle = -HORSE_power
			
	
	var break_force := 0.0
	if Input.is_action_pressed("s"):
		break_force = BREAK_power

	rear_left_wheel.engine_force = throttle
	rear_right_wheel.engine_force = throttle
	rear_left_wheel.brake = break_force
	rear_right_wheel.brake = break_force
	front_left_wheel.brake = break_force
	front_right_wheel.brake = break_force
