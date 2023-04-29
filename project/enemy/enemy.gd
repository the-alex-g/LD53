class_name Enemy
extends StaticBody2D

signal reached_end

@export var seconds_to_end := 15.0

@onready var handle : PathFollow2D = get_parent()


func _ready()->void:
	handle.loop = false


func _process(delta:float)->void:
	handle.progress_ratio += delta / seconds_to_end
	if handle.progress_ratio == 1.0:
		emit_signal("reached_end")


func damage(amount:int)->void:
	pass
