extends Node3D

@export var rain_main: GPUParticles3D
@export var rain_splash: GPUParticles3D
@export var player: Node3D    # your player or camera node
@export var coverage: Vector2 = Vector2(50, 50) # how wide the rain box should be
@onready var weather_control: Control = $"../weather control"

@export var rain_height: float = 50.0
@export var splash_height: float = 0.1
@export var weather_path: NodePath
var weather: Node
var rain = false
var paused = false
var mist = false
var mistheavy = false

func _ready():
	#setup_rain()
	$RainSystem/RainMain.emitting = false
	$RainSystem/RainSplash.emitting = false
	$RainSystem/Mist.emitting = false
	weather = get_node(weather_path)
	weather.weather_switch.connect(_on_weather_switch)
	weather_control.hide()

func _on_weather_switch(weather_type: String):
	if weather_type == 'Rain':
		rain = true
		setup_rain()
		#print("ON")
	elif weather_type == 'RainOff':
		rain = false
		$RainSystem/RainMain.emitting = false
		rain_splash.emitting = false
	elif weather_type == 'Mist':
		mist = true
		setup_mist()
		#print("ON")
		pass
	elif weather_type == 'MistOff':
		mist = false
		$RainSystem/Mist.emitting = false
		pass
	elif weather_type == 'Mist - Heavy':
		mistheavy = true
		setup_mist()
		pass
	elif weather_type == 'Mist - HeavyOff':
		mistheavy = false
		$RainSystem/Mist.emitting = false
		pass

func setup_rain():
	# Setup emission shapes
	if rain:
		$RainSystem/RainMain.emitting = true
		rain_splash.emitting = true
		#rain = true
		if $RainSystem/RainMain and $RainSystem/RainMain.process_material:
			var mat: ParticleProcessMaterial = $RainSystem/RainMain.process_material
			mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
			mat.emission_box_extents = Vector3(coverage.x / 2.0, 0.0, coverage.y / 2.0)

		if rain_splash and rain_splash.process_material:
			var mat2: ParticleProcessMaterial = rain_splash.process_material
			mat2.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
			mat2.emission_box_extents = Vector3(coverage.x / 2.0, 0.0, coverage.y / 2.0)

func setup_mist():
	if mist:
		$RainSystem/Mist.amount = 8000
		$RainSystem/Mist.emitting = true
		if $RainSystem/Mist and $RainSystem/Mist.process_material:
			var mat: ParticleProcessMaterial = $RainSystem/Mist.process_material
			mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
			mat.emission_box_extents = Vector3(coverage.x / 2.0, 2.5, coverage.y / 2.0)
	if mistheavy:
		$RainSystem/Mist.amount = 15000
		$RainSystem/Mist.emitting = true
		if $RainSystem/Mist and $RainSystem/Mist.process_material:
			var mat: ParticleProcessMaterial = $RainSystem/Mist.process_material
			mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
			mat.emission_box_extents = Vector3(coverage.x / 2.0, 2.5, coverage.y / 2.0)

func _process(delta: float) -> void:
	if rain:
		var player_pos = player.global_position
		rain_main.global_position = Vector3(player_pos.x, player_pos.y + rain_height, player_pos.z)
		rain_splash.global_position = Vector3(player_pos.x, splash_height, player_pos.z)
	
	if mist or mistheavy:
		var player_pos = player.global_position
		#print("HOWDY")
		$RainSystem/Mist.global_position = Vector3(player_pos.x, 2, player_pos.z)
	
	if Input.is_action_just_pressed("Escape"):
		if paused:
			get_tree().paused = false
			weather_control.hide()
			paused = false
		else:
			get_tree().paused = not get_tree().paused
			weather_control.visible = get_tree().paused
			paused = true
	
	setup_rain()
	setup_mist()
