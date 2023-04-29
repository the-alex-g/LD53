extends Node2D

const MAP_SIZE := 8
const TILE_SIZE := 8

var _unit_path_points : PackedVector2Array = []
var _unit_tower_positions : PackedVector2Array = []
var _can_place := false

@onready var _enemy_path : Path2D = $EnemyPath
@onready var _tilemap : TileMap = $TileMap
@onready var _tower_placement : Sprite2D = $TowerPlacement


func _ready()->void:
	randomize()
	_generate_enemy_path()
	_create_enemy()


func _process(_delta:float)->void:
	var mouse_unit_position := _tilemap.local_to_map(_tilemap.to_local(get_global_mouse_position()))
	if _unit_path_points.has(mouse_unit_position) or _unit_tower_positions.has(mouse_unit_position):
		_can_place = false
	else:
		_can_place = true
	
	if Input.is_action_just_pressed("place_tower") and _can_place:
		_place_tower(mouse_unit_position)
	
	_tower_placement.position = mouse_unit_position * TILE_SIZE
	_tower_placement.modulate = Color.LIGHT_SEA_GREEN if _can_place else Color.ORANGE_RED


func _generate_enemy_path()->void:
	_unit_path_points = [Vector2.ZERO]
	
	var sequence := []
	for _i in MAP_SIZE - 1:
		sequence.append("right")
		sequence.append("down")
	sequence.shuffle()
	
	for direction in sequence:
		match direction:
			"right":
				_unit_path_points.append(_unit_path_points[_unit_path_points.size() - 1] + Vector2.RIGHT)
			"down":
				_unit_path_points.append(_unit_path_points[_unit_path_points.size() - 1] + Vector2.DOWN)
	
	_generate_map(_unit_path_points)
	
	for point in _unit_path_points:
		_enemy_path.curve.add_point((point + Vector2.ONE / 2) * TILE_SIZE)


func _create_enemy()->void:
	var handle := PathFollow2D.new()
	_enemy_path.add_child(handle)
	
	var enemy : Enemy = preload("res://enemy/enemy.tscn").instantiate()
	enemy.reached_end.connect(_enemy_reached_end, CONNECT_ONE_SHOT)
	handle.add_child(enemy)


func _place_tower(unit_position:Vector2)->void:
	_unit_tower_positions.append(unit_position)
	var local_position := (unit_position + Vector2.ONE / 2) * TILE_SIZE
	var tower := preload("res://tower/tower.tscn").instantiate()
	tower.position = local_position
	add_child(tower)


func _enemy_reached_end()->void:
	print("losination on your part!")


func _generate_map(unit_path_points:PackedVector2Array)->void:
	_tilemap.set_cells_terrain_connect(0, unit_path_points, 0, 0)
