class_name Tower
extends Area2D

const TILE_SIZE := 8

@export var tiles_of_range := 2.0
@export var attack_delay_time := 1.0
@export var attack_damage := 1
@export var projectile_type : PackedScene

var _target : Enemy

@onready var _weapon_range := (tiles_of_range + 0.5) * TILE_SIZE
@onready var _attack_timer : Timer = $AttackTimer


func _ready()->void:
	$CollisionShape2D.shape.radius = _weapon_range


func _on_area_entered(area:Area2D)->void:
	if area is Enemy and _target == null:
		_target = area
		_attack_timer.start(attack_delay_time)


func _on_area_exited(area:Area2D)->void:
	if area == _target:
		_target = null
		_attack_timer.stop()


func _on_attack_timer_timeout()->void:
	var projectile : Area2D = projectile_type.instantiate()
	projectile.position = global_position
	projectile.direction = get_angle_to(_target.global_position) 
	projectile.damage = attack_damage
	get_parent().add_child(projectile)
