class_name Projectile
extends CharacterBody2D

@export var speed := 64.0

var direction := 0.0
var damage := 0
var type := ""

@onready var _sprite : AnimatedSprite2D = $Sprite


func _ready()->void:
	_sprite.play(type)
	_sprite.rotation = direction


func _process(delta:float)->void:
	var collision := move_and_collide(Vector2.RIGHT.rotated(direction) * speed * delta)
	if collision != null:
		collision.get_collider().damage(damage)
		queue_free()
