extends PathFollow3D

@export var max_speed: float = 1.0
@export var acceleration: float = 2
@export var deceleration: float = 5
@export var stop_distance: float = 8.0
@export var slow_distance: float = 15.0

var current_speed: float = 1
var ray: RayCast3D
var time_since_clear: float = 0.0
var reaction_delay: float = 1.5
var obstacle_detected: bool = false

func _ready():
	# Find the RayCast inside the Vehicle child scene
	var vehicle = get_child(0)  # Assuming the Vehicle is the only child
	if vehicle and vehicle.has_node("RayCast3D"):
		ray = vehicle.get_node("RayCast3D")
		ray.enabled = true
	else:
		push_warning("⚠️ Vehicle or RayCast3D not found in " + str(name))

func _physics_process(delta):
	if not ray:
		return

	var target_speed = max_speed
	var hit_something := false
	var desired_speed = max_speed

	if ray.is_colliding():
		var collider = ray.get_collider()
		#print("Ray hit:", collider.name, " dist:", ray.global_position.distance_to(ray.get_collision_point()))
		if collider.is_in_group("Traffic_triggers") or collider.is_in_group("player"):
			var hit_pos = ray.get_collision_point()
			var dist = global_position.distance_to(hit_pos)
			hit_something = true

			if dist < slow_distance:
				var factor = clamp((dist - stop_distance) / (slow_distance - stop_distance), 0.0, 1.0)
				desired_speed = max_speed * factor
	
	if hit_something:
		obstacle_detected = true
		time_since_clear = 0.0  # reset cooldown
		target_speed = desired_speed
	else:
		if obstacle_detected:
			# we just cleared an obstacle — start cooldown timer
			time_since_clear += delta
			if time_since_clear >= reaction_delay:
				obstacle_detected = false
				target_speed = max_speed
			else:
				# still in cooldown, stay at current speed
				target_speed = current_speed
		else:
			target_speed = max_speed

	# Smooth acceleration/deceleration
	if target_speed < current_speed:
		current_speed = lerp(current_speed, target_speed, delta * deceleration)
	else:
		current_speed = lerp(current_speed, target_speed, delta * acceleration)

	progress += current_speed * delta
