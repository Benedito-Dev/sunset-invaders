extends Node2D

## Fase principal.
##
## Orquestra um loop sem fim: onda de bandidos, depois o chefe, e de volta à
## onda de bandidos — só termina se o xerife morrer. Pontuação e o dano nas
## barreiras persistem de uma onda para a outra; a formação e o chefe nascem
## do zero a cada vez. A lógica de cada entidade mora na própria entidade —
## esta cena apenas coordena.

@onready var score: Label = $Background/Score
@export var cena_do_boss: PackedScene

var _bandidos_abatidos: float = 0
@onready var _total_de_bandidos: int = $Bandidos.colunas * $Bandidos.linhas

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
	_bandidos_abatidos += 1
	if _bandidos_abatidos >= _total_de_bandidos * 0.40:
		$Player.ativar_leque()

## O chefe caiu: soma os pontos e recomeça o loop com uma nova onda de
## bandidos, em vez de terminar o jogo. O jogo só acaba se o xerife morrer.
func _ao_abater_boss(pontos: int) -> void:
	somar_pontos(pontos)
	$Player.definir_controlavel(true)
	$Bandidos.iniciar_onda()


## Último bandido caiu: chama o chefe para a próxima etapa da onda.
func _ao_derrotar_formacao() -> void:
	var boss := cena_do_boss.instantiate()
	boss.position = Vector2(-20, 40)
	boss.patrulha_iniciada.connect(_ao_iniciar_patrulha_do_chefe)
	boss.abatido.connect(_ao_abater_boss)
	add_child(boss)
	$Player.definir_controlavel(false)


## Os bandidos chegaram à altura do xerife.
func _ao_formacao_alcancar_o_chao() -> void:
	terminar_em_derrota()


## O xerife perdeu a última vida.
func _ao_morrer_o_xerife() -> void:
	terminar_em_derrota()
	
func _ao_iniciar_patrulha_do_chefe() -> void:
	$Player.definir_controlavel(true)


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


func somar_pontos(pontos: int) -> void:
	pontuacao += pontos

func atualizar_score(new_score: int) -> void:
	score.text = "SCORE %d" % new_score
