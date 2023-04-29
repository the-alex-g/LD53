class_name Enemy
extends StaticBody2D

signal reached_end
signal died

@export var seconds_to_end := 15.0
@export var health := 10
@export var explosion_radius := 10.0

@onready var handle : PathFollow2D = get_parent()


func _ready()->void:
	handle.loop = false


func _process(delta:float)->void:
	handle.progress_ratio += delta / seconds_to_end
	if handle.progress_ratio == 1.0:
		emit_signal("reached_end")


func damage(amount:int)->void:
	health -= amount
	if health <= 0:
		_die()


func _die()->void:
	emit_signal("died")
	_explode()
	handle.queue_free()


func _explode()->void:
	var explosion := preload("res://enemy/enemy_explosion.tscn").instantiate()
	explosion.global_position = global_position
	explosion.explosion_radius = explosion_radius
	handle.get_parent().add_child(explosion)


func _draw()->void:
	draw_circle(Vector2.ZERO, 4.0, Color.DARK_RED)
