extends Node2D

## Fase principal.
##
## Orquestra a partida: instancia as ondas de bandidos, acompanha a pontuação
## e decide quando o jogo termina. A lógica de cada entidade mora na própria
## entidade — esta cena apenas coordena.

signal pontuacao_mudou(nova_pontuacao: int)

var pontuacao: int = 0:
	set(valor):
		pontuacao = valor
		pontuacao_mudou.emit(pontuacao)


func _ready() -> void:
	# TODO: montar a primeira onda de inimigos.
	pass


# TEMPORÁRIO: atalho para voltar à tela de início enquanto não há jogabilidade.
# Remova quando a derrota real existir.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SceneManager.ir_para_inicio()


## Chame quando o jogador perder a última vida.
func terminar_em_derrota() -> void:
	SceneManager.ir_para_derrota(pontuacao)


## Chame quando a última onda for derrotada.
func terminar_em_vitoria() -> void:
	SceneManager.ir_para_vitoria(pontuacao)


func somar_pontos(pontos: int) -> void:
	pontuacao += pontos
