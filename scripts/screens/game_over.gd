extends Control

## Tela de derrota.
##
## A pontuação da partida chega por `SceneManager.last_score` — a cena anterior
## já foi descarregada quando esta monta, então o valor vem do autoload.

@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	if score_label:
		score_label.text = "PONTUAÇÃO: %d" % SceneManager.last_score


func _on_retry_pressed() -> void:
	SceneManager.goto_game()


func _on_title_pressed() -> void:
	SceneManager.goto_title()
