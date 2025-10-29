extends VehicleBody3D

# --- Car movement parameters ---
@export var MAX_steering = 0.7
@export var HORSE_power = 4000
@export var BREAK_power = 100

@onready var front_left_wheel = $"front left" 
@onready var front_right_wheel = $"front right"
@onready var rear_left_wheel = $"back left2"
@onready var rear_right_wheel = $"back left"
@onready var wheel = $"steering wheel"

# --- Camera parameters ---
@export var camera_sensitivity = 0.003
@export var camera_look_limit = 0.6  # radians
@onready var camera = $Camera3D  # adjust path if camera is inside SpringArm3D

# --- Internal state ---
var forward = false
var reversOrNot := true
#var steering := 0.0

# Camera yaw state
var camera_yaw := 0.0
var base_yaw := 0.0 

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Store initial camera yaw
	base_yaw = camera.rotation.y

func _input(event):
	if event is InputEventMouseMotion:
		# Mouse horizontal movement controls camera yaw
		camera_yaw -= event.relative.x * camera_sensitivity
		camera_yaw = clamp(camera_yaw, -camera_look_limit, camera_look_limit)
		camera.rotation.y = base_yaw + camera_yaw

	if Input.is_action_just_pressed("q"):
		# Flip gear
		reversOrNot = !reversOrNot
		print("in reverse or not:", reversOrNot)

func _physics_process(delta):
	# --- Steering ---
	var steering_input = Input.get_axis("a","d") * MAX_steering * -1
	var wheel_turn = Input.get_axis("a","d") / 75
	wheel.rotate_x(wheel_turn)

	steering = move_toward(steering, steering_input, delta * 2)
	steering = clamp(steering, -MAX_steering, MAX_steering)
	front_left_wheel.steering = steering
	front_right_wheel.steering = steering
	#rear_left_wheel.steering = -steering * 0.2
	#rear_right_wheel.steering = -steering * 0.2

	# --- Throttle and brake ---
	var throttle := 0.0
	if Input.is_action_pressed("w"):
		throttle = HORSE_power if reversOrNot else -HORSE_power

	var break_force := 0.0
	if Input.is_action_pressed("s"):
		break_force = BREAK_power

	#rear_left_wheel.engine_force = throttle
	#rear_right_wheel.engine_force = throttle
	front_left_wheel.engine_force = throttle
	front_right_wheel.engine_force = throttle
	rear_left_wheel.brake = break_force
	rear_right_wheel.brake = break_force
	front_left_wheel.brake = break_force
	front_right_wheel.brake = break_force

	# --- Optional: Smoothly recenter camera when mouse not moving ---
	#if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		#camera_yaw = lerp(camera_yaw, 0.0, delta * 1.5)
		#camera.rotation.y = base_yaw + camera_yaw
