extends Node2D

## Fase principal.
##
## Orquestra a partida: instancia as ondas de bandidos, acompanha a pontuação
## e decide quando o jogo termina. A lógica de cada entidade mora na própria
## entidade — esta cena apenas coordena.

@onready var score: Label = $Background/Score
@export var cena_do_boss: PackedScene

signal pontuacao_mudou(nova_pontuacao: int)

func _ready() -> void:
	pontuacao_mudou.connect(atualizar_score)

var pontuacao: int = 0:
	set(valor):
		pontuacao = valor
		pontuacao_mudou.emit(pontuacao)


## A formação avisa a cada bandido derrubado.
func _ao_abater_bandido(pontos: int) -> void:
	somar_pontos(pontos)


## Último bandido caiu.
func _ao_derrotar_formacao() -> void:
	var boss := cena_do_boss.instantiate()
	boss.position = Vector2(-20, 40)
	add_child(boss)


## Os bandidos chegaram à altura do xerife.
func _ao_formacao_alcancar_o_chao() -> void:
	terminar_em_derrota()


## O xerife perdeu a última vida.
func _ao_morrer_o_xerife() -> void:
	terminar_em_derrota()


# TEMPORÁRIO: atalho para voltar à tela de início enquanto não há jogabilidade.
# Remova quando a derrota real existir.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SceneManager.ir_para_inicio()


## Chame quando o jogador perder a última vida.
func terminar_em_derrota() -> void:
	if ResourceLoader.exists(SceneManager.TELA_DERROTA):
		SceneManager.ir_para_derrota(pontuacao)
	else:
		# A tela de derrota ainda não existe; volta ao início para não travar.
		SceneManager.ir_para_inicio()


## Chame quando a última onda for derrotada.
func terminar_em_vitoria() -> void:
	if ResourceLoader.exists(SceneManager.TELA_VITORIA):
		SceneManager.ir_para_vitoria(pontuacao)
	else:
		SceneManager.ir_para_inicio()


func somar_pontos(pontos: int) -> void:
	pontuacao += pontos

func atualizar_score(new_score: int) -> void:
	score.text = "SCORE %d" % new_score
