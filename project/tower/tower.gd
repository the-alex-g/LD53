class_name Tower
extends Area2D

signal destroyed

const TILE_SIZE := 16

@export var range_in_tiles := 2.0
@export var attack_delay_time := 1.0
@export var attack_damage := 1
@export_enum("lance", "cannon", "bolt") var tower_type := "bolt"

var _target : Enemy = null
var armored := false

@onready var _range := (range_in_tiles + 0.5) * TILE_SIZE
@onready var _attack_timer : Timer = $AttackTimer
@onready var _collision_shape : CollisionShape2D = $AttackArea/CollisionShape2D
@onready var _armor : Sprite2D = $Base/Armor
@onready var _base : AnimatedSprite2D = $Base


func _ready()->void:
	# set the animation to the appropriate tower type
	_base.play(tower_type)


func _process(_delta:float)->void:
	# godot 4 bug workaround
	_collision_shape.shape.radius = _range


func _on_attack_timer_timeout()->void:
	# make sure the target is within range
	if is_instance_valid(_target):
		if _target.global_position.distance_to(global_position) > _range:
			_target = null
			_attack_timer.stop()
			return
	else:
		_target = null
		_attack_timer.stop()
		return
	
	# if it is, shoot
	var projectile : Projectile = preload("res://projectiles/projectile.tscn").instantiate()
	$ShootSound.m_play()
	projectile.type = tower_type
	projectile.position = global_position
	projectile.direction = get_angle_to(_target.global_position) 
	projectile.damage = attack_damage
	get_parent().add_child(projectile)


func _on_body_entered(body:PhysicsBody2D)->void:
	if body is Enemy and _target == null:
		_target = body
		_attack_timer.start(attack_delay_time)


func armor()->void:
	armored = true
	_armor.visible = true


func damage()->void:
	if armored:
		armored = false
		_armor.visible = false
	else:
		emit_signal("destroyed")
		_remove_tower()


func destroy()->void:
	# this method is called by the main scene when the game ends.
	var explosion : CPUParticles2D = load("res://tower/tower_explosion.tscn").instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	_remove_tower()


func _remove_tower()->void:
	hide()
	$CollapseSound.play()


func _on_collapse_sound_finished():
	queue_free()
