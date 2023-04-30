extends CanvasLayer

signal selection_changed(new_selection)
signal start_game

var _score := 0

@onready var _scrap_label : Label = $Control/ScrapLabel
@onready var _score_label : Label = $Control/ScoreLabel
@onready var _bolt_button : Button = $TowerTypes/Bolt
@onready var _cannon_button : Button = $TowerTypes/Cannon
@onready var _lance_button : Button = $TowerTypes/Lance
@onready var _armor_button : Button = $TowerTypes/Armor


func _ready()->void:
	_bolt_button.button_pressed = true
	_bolt_button.grab_focus()


func _on_main_update_scrap(value:int)->void:
	_scrap_label.text = "Scrap: " + str(value)


func _on_main_update_score(value:int)->void:
	_score = value
	_score_label.text = "Score: " + str(value)


func _on_bolt_toggled(button_pressed:bool)->void:
	if button_pressed:
		_cannon_button.set_pressed_no_signal(false)
		_lance_button.set_pressed_no_signal(false)
		_armor_button.set_pressed_no_signal(false)
		emit_signal("selection_changed", "bolt")
	else:
		_bolt_button.set_pressed_no_signal(true)


func _on_cannon_toggled(button_pressed:bool)->void:
	if button_pressed:
		_bolt_button.set_pressed_no_signal(false)
		_lance_button.set_pressed_no_signal(false)
		_armor_button.set_pressed_no_signal(false)
		emit_signal("selection_changed", "cannon")
	else:
		_cannon_button.set_pressed_no_signal(true)


func _on_lance_toggled(button_pressed:bool)->void:
	if button_pressed:
		_cannon_button.set_pressed_no_signal(false)
		_bolt_button.set_pressed_no_signal(false)
		_armor_button.set_pressed_no_signal(false)
		emit_signal("selection_changed", "lance")
	else:
		_lance_button.set_pressed_no_signal(true)


func _on_armor_toggled(button_pressed:bool)->void:
	if button_pressed:
		_cannon_button.set_pressed_no_signal(false)
		_lance_button.set_pressed_no_signal(false)
		_bolt_button.set_pressed_no_signal(false)
		emit_signal("selection_changed", "armor")
	else:
		_armor_button.set_pressed_no_signal(true)


func _on_main_game_over()->void:
	$GameOverPanel/VBoxContainer/Label.text = "You got " + str(_score) + " points!"
	$GameOverPanel.visible = true


func _on_play_again_pressed()->void:
	$GameOverPanel.visible = false
	emit_signal("start_game")


func _on_main_menu_pressed()->void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
