extends Node3D

# --------------------
# Exported properties
# --------------------
@export var grid_size_x: int = 50
@export var grid_size_z: int = 50
@export var spacing: float = 10.0
@export var scaling: float = 0.9
@export var save_scene: bool = false

# --------------------
# Variables
# --------------------
var commercial_buildings: Array[PackedScene] = []
var roads: Dictionary = {}
var commercial_road_grid: Dictionary = {}

# Root node for all generated content
var city_root: Node3D
var roads_root: Node3D
var buildings_root: Node3D

# --------------------
# Ready function
# --------------------
func _ready():
	randomize()
	load_assets()

	# Create root container
	city_root = Node3D.new()
	city_root.name = "GeneratedCity"
	add_child(city_root)

	# Create subcontainers
	roads_root = Node3D.new()
	roads_root.name = "Roads"
	city_root.add_child(roads_root)

	buildings_root = Node3D.new()
	buildings_root.name = "Buildings"
	city_root.add_child(buildings_root)

	# Generate content
	generate_roads()
	generate_buildings()

	# Save after deferred to ensure all nodes exist
	if save_scene:
		call_deferred("_save_city")

# --------------------
# Load assets as PackedScenes
# --------------------
func load_assets():
	commercial_buildings = [
		preload("res://scenes/Commercial Buildings/building_a.tscn"),
		preload("res://scenes/Commercial Buildings/building_b.tscn"),
		preload("res://scenes/Commercial Buildings/building_c_2.tscn"),
		preload("res://scenes/Commercial Buildings/building_d_2.tscn"),
		preload("res://scenes/Commercial Buildings/building_f_2.tscn"),
		preload("res://scenes/Commercial Buildings/building_g_2.tscn"),
		preload("res://scenes/Commercial Buildings/building_h_2.tscn"),
		preload("res://scenes/Commercial Buildings/building_i_2.tscn"),
		preload("res://scenes/Commercial Buildings/building_l_2.tscn"),
		preload("res://scenes/Commercial Buildings/building_m_2.tscn"),
		preload("res://scenes/Commercial Buildings/building_skyscraper_a_2.tscn"),
		preload("res://scenes/Commercial Buildings/building_skyscraper_b_2.tscn"),
		preload("res://scenes/Commercial Buildings/building_skyscraper_c_2.tscn"),
		preload("res://scenes/Commercial Buildings/building_skyscraper_d_2.tscn")
	]

	roads = {
		"straight": preload("res://scenes/Road/road_straight_2.tscn"),
		"corner": preload("res://scenes/Road/road_bend_2.tscn"),
		"t": preload("res://scenes/Road/road_intersection_path_2.tscn"),
		"cross": preload("res://scenes/Road/road_crossroad_path_2.tscn")
	}

# --------------------
# Generate roads
# --------------------
func generate_roads():
	for x in range(grid_size_x):
		for z in range(grid_size_z):
			var pos = Vector2i(x, z)
			
			# Edge roads
			if x == 0 or x == grid_size_x - 1 or z == 0 or z == grid_size_z - 1:
				commercial_road_grid[pos] = true
			# Interior roads
			elif x % 8 == 0 or z % 6 == 0:
				commercial_road_grid[pos] = true

	for pos in commercial_road_grid.keys():
		var road_scene: PackedScene = roads[get_road_type(pos, commercial_road_grid)]
		var road_instance: Node3D = road_scene.instantiate() as Node3D
		road_instance.position = Vector3(pos.x * spacing, 0, pos.y * spacing)
		rotate_road(road_instance, get_road_type(pos, commercial_road_grid), pos, commercial_road_grid)
		roads_root.add_child(road_instance)

# --------------------
# Generate buildings
# --------------------
func generate_buildings():
	for x in range(1, grid_size_x - 1): # skip edges
		for z in range(1, grid_size_z - 1): # skip edges
			var pos = Vector2i(x, z)
			if !commercial_road_grid.has(pos):
				var building_scene: PackedScene = commercial_buildings.pick_random()
				var building_instance: Node3D = building_scene.instantiate() as Node3D
				building_instance.position = Vector3(x * spacing, 0, z * spacing)
				building_instance.rotation.y = deg_to_rad(90 * randi() % 4)
				building_instance.scale = Vector3(scaling, 1, scaling)
				buildings_root.add_child(building_instance)

# --------------------
# Road helpers
# --------------------
func get_road_type(pos: Vector2i, grid: Dictionary) -> String:
	var directions = [Vector2i(0,1), Vector2i(1,0), Vector2i(0,-1), Vector2i(-1,0)]
	var neighbors = []
	for dir in directions:
		if grid.has(pos + dir):
			neighbors.append(dir)

	var count = neighbors.size()
	if count == 4:
		return "cross"
	elif count == 3:
		return "t"
	elif count == 2:
		if (neighbors[0].x == 0 and neighbors[1].x == 0) or (neighbors[0].y == 0 and neighbors[1].y == 0):
			return "straight"
		else:
			return "corner"
	elif count == 1:
		return "straight"
	return "straight"

func rotate_road(road: Node3D, type: String, pos: Vector2i, grid: Dictionary):
	var rot = 0.0
	var up = Vector2i(0, -1)
	var down = Vector2i(0, 1)
	var left = Vector2i(-1, 0)
	var right = Vector2i(1, 0)

	match type:
		"straight":
			if grid.has(pos + up) and grid.has(pos + down):
				rot = deg_to_rad(90)
		"corner":
			if grid.has(pos + right) and grid.has(pos + down):
				rot = deg_to_rad(0)
			elif grid.has(pos + down) and grid.has(pos + left):
				rot = deg_to_rad(90)
			elif grid.has(pos + left) and grid.has(pos + up):
				rot = deg_to_rad(180)
			elif grid.has(pos + up) and grid.has(pos + right):
				rot = deg_to_rad(270)
		"t":
			if !grid.has(pos + up):
				rot = deg_to_rad(0)
			elif !grid.has(pos + left):
				rot = deg_to_rad(90)
			elif !grid.has(pos + down):
				rot = deg_to_rad(180)
			elif !grid.has(pos + right):
				rot = deg_to_rad(270)
		"cross":
			rot = deg_to_rad(0)
	road.rotation.y = rot

# --------------------
# Save the city
# --------------------
func _save_city():
	var packed_scene = PackedScene.new()
	var pack_result = packed_scene.pack(city_root)
	if pack_result != OK:
		push_error("Failed to pack city: %s" % pack_result)
		return

	var save_result = ResourceSaver.save(packed_scene, "res://generated_city.tscn")
	ResourceSaver.save(packed_scene, "res://generated_city.tscn")
	if save_result == OK:
		print("City saved successfully!")
	else:
		push_error("Failed to save city: %s" % save_result)
