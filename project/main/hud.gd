extends CanvasLayer

@onready var _scrap_label : Label = $Control/ScrapLabel
@onready var _score_label : Label = $Control/ScoreLabel


func _on_main_update_scrap(value:int)->void:
	_scrap_label.text = "Scrap: " + str(value)


func _on_main_update_score(value:int)->void:
	_score_label.text = "Score: " + str(value)
