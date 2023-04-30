extends Control

var _sfx_bus_index := AudioServer.get_bus_index("SFX")
var _music_bus_index := AudioServer.get_bus_index("Music")


func _ready()->void:
	Jukebox.play_main()
	$MenuButtons/Fullscreen.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	$MenuButtons/MusicMute.button_pressed = AudioServer.is_bus_mute(_music_bus_index)
	$MenuButtons/SFXMute.button_pressed = AudioServer.is_bus_mute(_sfx_bus_index)


func _on_play_pressed()->void:
	get_tree().change_scene_to_file("res://main/main.tscn")


func _on_fullscreen_toggled(button_pressed:bool)->void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_music_mute_toggled(button_pressed:bool)->void:
	AudioServer.set_bus_mute(_music_bus_index, button_pressed)


func _on_sfx_mute_toggled(button_pressed:bool)->void:
	AudioServer.set_bus_mute(_sfx_bus_index, button_pressed)
