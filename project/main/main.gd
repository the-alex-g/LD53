extends Node2D

signal update_scrap(value)
signal update_score(value)

enum Towers {ARMOR, BOLT, CANNON, LANCE}

const MAP_SIZE := 8
const TILE_SIZE := 8
const TOWER_COSTS := {
	Towers.ARMOR:1,
	Towers.BOLT:2,
	Towers.CANNON:4,
	Towers.LANCE:4,
}
const TOWER_STRINGS := {
	Towers.BOLT:"bolt",
	Towers.CANNON:"cannon",
	Towers.LANCE:"lance",
}

var _unit_path_points : PackedVector2Array = []
var _can_place := false
var _enemies_created := 0
var _scrap := 10 : set = _set_scrap
var _tower_selected := Towers.BOLT
var _score := 0 : set = _set_score
var _towers := {}

@onready var _enemy_path : Path2D = $EnemyPath
@onready var _tilemap : TileMap = $TileMap
@onready var _tower_placement : Sprite2D = $TowerPlacement


func _ready()->void:
	randomize()
	_start_game()


func _process(_delta:float)->void:
	var mouse_unit_position := _tilemap.local_to_map(_tilemap.to_local(get_global_mouse_position()))
	_evaluate_can_place(mouse_unit_position)
	
	if Input.is_action_just_pressed("place_tower") and _can_place:
		_place_tower(mouse_unit_position)
	
	if mouse_unit_position.y > MAP_SIZE - 1 or mouse_unit_position.x > MAP_SIZE - 1:
		# cursor off board, make it invisible
		_tower_placement.modulate = Color(1.0, 1.0, 1.0, 0.0)
	else:
		_tower_placement.position = mouse_unit_position * TILE_SIZE
		_tower_placement.modulate = Color(Color.LIGHT_SEA_GREEN, 0.5) if _can_place else Color(Color.ORANGE_RED, 0.5)


func _evaluate_can_place(mouse_unit_position:Vector2)->void:
	if _tower_placement.modulate != Color(1.0, 1.0, 1.0, 0.0):
		if _tower_selected != Towers.ARMOR:
			if _unit_path_points.has(mouse_unit_position) or _towers.has(mouse_unit_position) or _scrap < _get_tower_cost():
				_can_place = false
			else:
				_can_place = true
		else:
			if _towers.has(mouse_unit_position) and _scrap >= _get_tower_cost():
				if _towers[mouse_unit_position].armored:
					_can_place = false
				else:
					_can_place = true
			else:
				_can_place = false
	else:
		_can_place = false



func _start_game()->void:
	_generate_enemy_path()
	_create_enemy()
	_set_score(0)
	_set_scrap(10)


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


func _create_enemy(upgrades := 0)->void:
	if upgrades > 0:
		_set_scrap(_scrap + upgrades)
		_set_score(_score + upgrades)
	
	var handle := PathFollow2D.new()
	_enemy_path.add_child(handle)
	
	var enemy : Enemy = preload("res://enemy/enemy.tscn").instantiate()
	enemy.upgrades = _enemies_created
	enemy.reached_end.connect(_enemy_reached_end, CONNECT_ONE_SHOT)
	enemy.died.connect(_create_enemy.bind(_enemies_created), CONNECT_ONE_SHOT)
	handle.add_child(enemy)
	_enemies_created += 1


func _place_tower(unit_position:Vector2)->void:
	_set_scrap(_scrap - _get_tower_cost())
	
	if _tower_selected != Towers.ARMOR:
		var local_position := (unit_position + Vector2.ONE / 2) * TILE_SIZE
		
		var tower : Tower = load("res://tower/" + TOWER_STRINGS[_tower_selected] + "_tower.tscn").instantiate()
		tower.destroyed.connect(_tower_destroyed.bind(unit_position, _get_tower_cost()), CONNECT_ONE_SHOT)
		tower.position = local_position
		$TowerContainer.add_child(tower)
		_towers[unit_position] = tower
	else:
		_towers[unit_position].armor()


func _tower_destroyed(tower_position:Vector2, tower_cost:int)->void:
	_set_scrap(_scrap + floor(tower_cost / 2.0))
	_towers.erase(tower_position)


func _enemy_reached_end()->void:
	print("losination on your part!")


func _generate_map(unit_path_points:PackedVector2Array)->void:
	_tilemap.set_cells_terrain_connect(0, unit_path_points, 0, 0)


func _set_scrap(value:int)->void:
	_scrap = value
	emit_signal("update_scrap", value)


func _set_score(value:int)->void:
	_score = value
	emit_signal("update_score", value)


func _get_tower_cost()->int:
	return TOWER_COSTS[_tower_selected]


func _on_hud_selection_changed(new_selection:String)->void:
	match new_selection:
		"armor":
			_tower_selected = Towers.ARMOR
		"bolt":
			_tower_selected = Towers.BOLT
		"cannon":
			_tower_selected = Towers.CANNON
		"lance":
			_tower_selected = Towers.LANCE
