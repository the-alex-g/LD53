extends Node2D

const MAP_SIZE := 8
const TILE_SIZE := 8

@onready var _enemy_path : Path2D = $EnemyPath
@onready var _tilemap : TileMap = $TileMap


func _ready()->void:
	randomize()
	_generate_enemy_path()
	_create_enemy()


func _generate_enemy_path()->void:
	var sequence := []
	for _i in MAP_SIZE:
		sequence.append("right")
		sequence.append("down")
	sequence.shuffle()
	
	var unit_path_points : PackedVector2Array = [Vector2.ZERO]
	for direction in sequence:
		match direction:
			"right":
				unit_path_points.append(unit_path_points[unit_path_points.size() - 1] + Vector2.RIGHT)
			"down":
				unit_path_points.append(unit_path_points[unit_path_points.size() - 1] + Vector2.DOWN)
	
	_generate_map(unit_path_points)
	
	for point in unit_path_points:
		_enemy_path.curve.add_point((point + Vector2.ONE / 2) * TILE_SIZE)


func _create_enemy()->void:
	var handle := PathFollow2D.new()
	_enemy_path.add_child(handle)
	
	var enemy : Enemy = preload("res://enemy/enemy.tscn").instantiate()
	enemy.reached_end.connect(_enemy_reached_end, CONNECT_ONE_SHOT)
	handle.add_child(enemy)


func _enemy_reached_end()->void:
	print("losination on your part!")


func _generate_map(unit_path_points:PackedVector2Array)->void:
	pass
