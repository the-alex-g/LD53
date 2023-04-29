extends CanvasLayer

@onready var _scrap_label : Label = $Control/ScrapLabel


func _on_main_update_scrap(value:int)->void:
	_scrap_label.text = "Scrap: " + str(value)
