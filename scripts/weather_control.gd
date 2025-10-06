extends Control

@onready var rain: CheckButton = $MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/Rain
@onready var mist: CheckButton = $MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/Mist
@onready var snow: CheckButton = $MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/Snow
@onready var heavy_wind: CheckButton = $"MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/Mist - Heavy"
@onready var intense_sunlight: CheckButton = $"MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/Intense Sunlight"
@onready var random: CheckButton = $MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/Random
const RainSystem = preload("res://scripts/rain_system.gd")
var weather_change: String
@onready var storm: CheckButton = $MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/Storm
@onready var night: CheckButton = $MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/Night

signal weather_switch(weather_change: String)

func _process(delta: float) -> void:
	return


func _on_rain_toggled(toggled_on: bool) -> void:
	if toggled_on:
		weather_change='Rain'
		emit_signal("weather_switch", weather_change)
	else:
		weather_change='RainOff'
		emit_signal("weather_switch", weather_change)


func _on_mist_toggled(toggled_on: bool) -> void:
	if toggled_on:
		weather_change='Mist'
		emit_signal("weather_switch", weather_change)
		heavy_wind.button_pressed = false
	else:
		weather_change='MistOff'
		emit_signal("weather_switch", weather_change)


func _on_snow_toggled(toggled_on: bool) -> void:
	if toggled_on:
		weather_change='Snow'
		emit_signal("weather_switch", weather_change)
	else:
		weather_change='SnowOff'
		emit_signal("weather_switch", weather_change)


func _on_heavy_wind_toggled(toggled_on: bool) -> void:
	if toggled_on:
		weather_change='Mist - Heavy'
		emit_signal("weather_switch", weather_change)
		mist.button_pressed = false
	else:
		weather_change='Mist - HeavyOff'
		emit_signal("weather_switch", weather_change)


func _on_intense_sunlight_toggled(toggled_on: bool) -> void:
	if toggled_on:
		weather_change='Sunlight'
		emit_signal("weather_switch", weather_change)
	else:
		weather_change='SunlightOff'
		emit_signal("weather_switch", weather_change)


func _on_random_toggled(toggled_on: bool) -> void:
	if toggled_on:
		weather_change='Rand'
		emit_signal("weather_switch", weather_change)
		rain.button_pressed = true
		mist.button_pressed = true
		storm.button_pressed = true
		night.button_pressed = true
	else:
		weather_change='RandOff'
		emit_signal("weather_switch", weather_change)


func _on_storm_toggled(toggled_on: bool) -> void:
	if toggled_on:
		weather_change='Storm'
		emit_signal("weather_switch", weather_change)
	else:
		weather_change='StormOff'
		emit_signal("weather_switch", weather_change)


func _on_night_toggled(toggled_on: bool) -> void:
	if toggled_on:
		weather_change='Night'
		emit_signal("weather_switch", weather_change)
	else:
		weather_change='NightOff'
		emit_signal("weather_switch", weather_change)
