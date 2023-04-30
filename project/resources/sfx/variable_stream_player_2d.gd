class_name VariableStreamPlayer2D
extends AudioStreamPlayer2D

@export var volume_variation := 2.0
@export var pitch_variation := 0.5

@onready var _initial_volume := volume_db
@onready var _initial_pitch := pitch_scale


func _ready()->void:
	if autoplay:
		stop()
		m_play()


func m_play(from := 0.0)->void:
	volume_db = _initial_volume + randf_range(-volume_variation, volume_variation)
	pitch_scale = _initial_pitch + randf_range(-pitch_variation, pitch_variation)
	play(from)

