extends Control

## Tela de vitória.
##
## Mesma mecânica da derrota: a pontuação vem de `SceneManager.last_score`.

@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	if score_label:
		score_label.text = "PONTUAÇÃO: %d" % SceneManager.last_score


func _on_play_again_pressed() -> void:
	SceneManager.goto_game()


func _on_title_pressed() -> void:
	SceneManager.goto_start_screen()
