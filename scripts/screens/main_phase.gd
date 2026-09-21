extends Node2D

## Fase principal.
##
## Orquestra a partida: instancia as ondas de bandidos, acompanha a pontuação
## e decide quando o jogo termina. A lógica de cada entidade mora na própria
## entidade — esta cena apenas coordena.

signal score_changed(new_score: int)

var score: int = 0:
	set(value):
		score = value
		score_changed.emit(score)


func _ready() -> void:
	# TODO: montar a primeira onda de inimigos.
	pass


## Chame quando o jogador perder a última vida.
func end_in_defeat() -> void:
	SceneManager.goto_game_over(score)


## Chame quando a última onda for derrotada.
func end_in_victory() -> void:
	SceneManager.goto_victory(score)


func add_score(points: int) -> void:
	score += points
