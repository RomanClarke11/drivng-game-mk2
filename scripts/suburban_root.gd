extends Node3D

@export var grid_size_x: int = 15
@export var grid_size_z: int = 15
@export var spacing: float = 8.0 # increased spacing
@export var model_scale: float = 0.7 # controls visual space around objects

@onready var camera_3d = $Camera3D

var buildings = []
var roads = {}
var road_grid = {}

func _ready():
	randomize()
	load_assets()
	generate_roads()
	generate_buildings()
	
	#camera_3d.position = Vector3(grid_size_x * spacing / 2, 30, grid_size_z * spacing / 2 + 20)
	#camera_3d.look_at(Vector3(grid_size_x * spacing / 2, 0, grid_size_z * spacing / 2), Vector3.UP)
	#camera_3d.current = true

func load_assets():
	buildings = [
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-a.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-b.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-c.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-d.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-e.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-g.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-h.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-i.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-j.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-k.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-l.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-o.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-p.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-q.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-r.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-s.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-t.glb"),
		preload("res://assets/Suburban Buildings/Models/GLB format/building-type-u.glb"),
	]

	roads = {
		"straight": preload("res://assets/Roads/Models/GLB format/road-straight.glb"),
		"corner": preload("res://assets/Roads/Models/GLB format/road-bend.glb"),
		"t": preload("res://assets/Roads/Models/GLB format/road-intersection-path.glb"),
		"cross": preload("res://assets/Roads/Models/GLB format/road-crossroad-path.glb")
	}

func generate_roads():
	for x in range(grid_size_x):
		for z in range(grid_size_z):
			var pos = Vector2i(x, z)
			if x % 6 == 0 or z % 3 == 0:
				road_grid[pos] = true

	for pos in road_grid.keys():
		var road_type = get_road_type(pos)
		var road = roads[road_type].instantiate()
		road.position = Vector3(pos.x * spacing, 0, pos.y * spacing)
		#road.scale = Vector3(model_scale, model_scale, model_scale) # scale roads down
		rotate_road(road, road_type, pos)
		add_child(road)

func generate_buildings():
	for x in range(grid_size_x):
		for z in range(grid_size_z):
			var pos = Vector2i(x, z)
			if road_grid.has(pos):
				continue

			var building = buildings.pick_random().instantiate()
			building.position = Vector3(x * spacing, 0, z * spacing)
			building.scale = Vector3(model_scale, 1, 1) # scale buildings down
			add_child(building)

func get_road_type(pos: Vector2i) -> String:
	var directions = [Vector2i(0,1), Vector2i(1,0), Vector2i(0,-1), Vector2i(-1,0)]
	var neighbors = []
	for dir in directions:
		if road_grid.has(pos + dir):
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

func rotate_road(road: Node3D, type: String, pos: Vector2i):
	var rot = 0.0
	var up = Vector2i(0, -1)
	var down = Vector2i(0, 1)
	var left = Vector2i(-1, 0)
	var right = Vector2i(1, 0)

	match type:
		"straight":
			if has_neighbor(pos, up) and has_neighbor(pos, down):
				rot = deg_to_rad(90)
		"corner":
			if has_neighbor(pos, right) and has_neighbor(pos, down):
				rot = deg_to_rad(0)
			elif has_neighbor(pos, down) and has_neighbor(pos, left):
				rot = deg_to_rad(90)
			elif has_neighbor(pos, left) and has_neighbor(pos, up):
				rot = deg_to_rad(180)
			elif has_neighbor(pos, up) and has_neighbor(pos, right):
				rot = deg_to_rad(270)
		"t":
			if !has_neighbor(pos, up):
				rot = deg_to_rad(0)
			elif !has_neighbor(pos, left):
				rot = deg_to_rad(90)
			elif !has_neighbor(pos, down):
				rot = deg_to_rad(180)
			elif !has_neighbor(pos, right):
				rot = deg_to_rad(270)
		"cross":
			rot = deg_to_rad(0)
	road.rotation.y = rot

func has_neighbor(pos: Vector2i, dir: Vector2i) -> bool:
	return road_grid.has(pos + dir)
