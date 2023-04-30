extends CanvasLayer

signal selection_changed(new_selection)
signal start_game

var _score := 0

@onready var _scrap_label : Label = $Control/HBoxContainer/ScrapLabel
@onready var _score_label : Label = $Control/HBoxContainer/ScoreLabel
@onready var _bolt_button : Button = $TowerTypes/Bolt
@onready var _cannon_button : Button = $TowerTypes/Cannon
@onready var _lance_button : Button = $TowerTypes/Lance
@onready var _armor_button : Button = $TowerTypes/Armor
@onready var _button_sound : AudioStreamPlayer = $ButtonSound


func _ready()->void:
	_bolt_button.button_pressed = true


func _input(event:InputEvent)->void:
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_KP_1, KEY_1:
				_bolt_button.button_pressed = true
			KEY_KP_2, KEY_2:
				_cannon_button.button_pressed = true
			KEY_KP_3, KEY_3:
				_lance_button.button_pressed = true
			KEY_KP_4, KEY_4:
				_armor_button.button_pressed = true


func _on_main_update_scrap(value:int)->void:
	_scrap_label.text = "Scrap: " + str(value)


func _on_main_update_score(value:int)->void:
	_score = value
	_score_label.text = "Score: " + str(value)


func play_button_sound()->void:
	_button_sound.play()


func _on_bolt_toggled(button_pressed:bool)->void:
	_bolt_button.grab_focus()
	if button_pressed:
		_cannon_button.set_pressed_no_signal(false)
		_lance_button.set_pressed_no_signal(false)
		_armor_button.set_pressed_no_signal(false)
		emit_signal("selection_changed", "bolt")
		_button_sound.play()
	else:
		# if the button is pressed while it's already pressed
		_bolt_button.set_pressed_no_signal(true)


func _on_cannon_toggled(button_pressed:bool)->void:
	_cannon_button.grab_focus()
	if button_pressed:
		_bolt_button.set_pressed_no_signal(false)
		_lance_button.set_pressed_no_signal(false)
		_armor_button.set_pressed_no_signal(false)
		emit_signal("selection_changed", "cannon")
		_button_sound.play()
	else:
		_cannon_button.set_pressed_no_signal(true)


func _on_lance_toggled(button_pressed:bool)->void:
	_lance_button.grab_focus()
	if button_pressed:
		_cannon_button.set_pressed_no_signal(false)
		_bolt_button.set_pressed_no_signal(false)
		_armor_button.set_pressed_no_signal(false)
		emit_signal("selection_changed", "lance")
		_button_sound.play()
	else:
		_lance_button.set_pressed_no_signal(true)


func _on_armor_toggled(button_pressed:bool)->void:
	_armor_button.grab_focus()
	if button_pressed:
		_cannon_button.set_pressed_no_signal(false)
		_lance_button.set_pressed_no_signal(false)
		_bolt_button.set_pressed_no_signal(false)
		emit_signal("selection_changed", "armor")
		_button_sound.play()
	else:
		_armor_button.set_pressed_no_signal(true)


func _on_main_game_over()->void:
	$GameOverPanel/VBoxContainer/Label.text = "You got " + str(_score) + " points!"
	$GameOverPanel.visible = true


func _on_play_again_pressed()->void:
	$GameOverPanel.visible = false
	_button_sound.play()
	emit_signal("start_game")


func _on_main_menu_pressed()->void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
