extends Area2D

var explosion_radius := 10.0

@onready var _particles : CPUParticles2D = $CPUParticles2D


func _ready()->void:
	$CollisionShape2D.shape.radius = explosion_radius
	
	_particles.lifetime = sqrt(explosion_radius) / 6.3
	_particles.initial_velocity_min = explosion_radius / _particles.lifetime
	_particles.amount = ceil(pow(explosion_radius, 2) * PI / 10.0)
	_particles.emitting = true
	
	await get_tree().create_timer(_particles.lifetime).timeout
	
	queue_free()


func _on_area_entered(area:Area2D)->void:
	area.damage()
