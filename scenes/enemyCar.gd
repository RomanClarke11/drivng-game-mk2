extends PathFollow3D

@export var max_speed: float = 1.0
@export var acceleration: float = 8
@export var deceleration: float = 5
@export var stop_distance: float = 8.0
@export var slow_distance: float = 15.0
@export var reaction_delay: float = 1.0  # seconds

var current_speed: float = 1
var ray: RayCast3D
var time_since_clear: float = 0.0
var obstacle_detected: bool = false

func _ready():
	# Find the RayCast inside the vehicle child scene
	for child in get_children():
		if child.has_node("RayCast3D"):
			ray = child.get_node("RayCast3D")
			ray.enabled = true
			#ray.debug = true
	if not ray:
		push_warning("⚠️ No RayCast3D found in vehicle " + str(name))

func _physics_process(delta):
	if not ray:
		return

	var target_speed = max_speed
	var hit_something = false

	# Ray detection
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("Traffic_triggers") or collider.is_in_group("player"):
			var hit_pos = ray.get_collision_point()
			var dist = global_position.distance_to(hit_pos)
			hit_something = true
			if dist < slow_distance:
				var factor = clamp((dist - stop_distance) / (slow_distance - stop_distance), 0.0, 1.0)
				target_speed = max_speed * factor
			else:
				target_speed = max_speed

	if hit_something:
		obstacle_detected = true
		time_since_clear = 0.0
	else:
		if obstacle_detected:
			time_since_clear += delta
			if time_since_clear >= reaction_delay:
				obstacle_detected = false
				target_speed = max_speed
			else:
				target_speed = current_speed
		else:
			target_speed = max_speed

	# Smooth acceleration / deceleration
	if target_speed < current_speed:
		current_speed = move_toward(current_speed, target_speed, deceleration * delta)
	else:
		current_speed = move_toward(current_speed, target_speed, acceleration * delta)

	progress += current_speed * delta
	#ray.debug = true
