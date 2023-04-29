extends Area2D

var explosion_radius := 10.0

@onready var _particles : CPUParticles2D = $CPUParticles2D


func _ready()->void:
	$CollisionShape2D.shape.radius = explosion_radius
	_particles.emitting = true
	$LifeTimer.start(_particles.lifetime)
	await $LifeTimer.timeout
	queue_free()


func _on_area_entered(area:Area2D)->void:
	area.damage()
