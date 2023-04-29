class_name Tower
extends Area2D

signal destroyed

const TILE_SIZE := 8

@export var range_in_tiles := 2.0
@export var attack_delay_time := 1.0
@export var attack_damage := 1
@export var projectile_type : PackedScene

var _target : Enemy = null

@onready var _range := (range_in_tiles + 0.5) * TILE_SIZE
@onready var _attack_timer : Timer = $AttackTimer
@onready var _collision_shape : CollisionShape2D = $AttackArea/CollisionShape2D


func _process(_delta:float)->void:
	# godot 4 bug workaround
	_collision_shape.shape.radius = _range


func _on_attack_timer_timeout()->void:
	var projectile : Projectile = projectile_type.instantiate()
	projectile.position = global_position
	projectile.direction = get_angle_to(_target.global_position) 
	projectile.damage = attack_damage
	get_parent().add_child(projectile)


func _on_body_entered(body:PhysicsBody2D)->void:
	if body is Enemy and _target == null:
		_target = body
		_attack_timer.start(attack_delay_time)


func _on_body_exited(body:PhysicsBody2D)->void:
	if body == _target:
		_target = null
		_attack_timer.stop()


func damage()->void:
	emit_signal("destroyed")
	queue_free()
