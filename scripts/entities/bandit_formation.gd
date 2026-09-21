extends Node2D

## A formação de bandidos.
##
## Monta a grade e move todos juntos: avança na horizontal até alguém encostar
## na borda, então desce um degrau e inverte o sentido. A cada passo os bandidos
## trocam de pose, o que cria o ritmo característico do gênero.

## Emitido quando o último bandido cai.
signal formacao_derrotada

## Emitido quando a formação chega à altura do xerife.
signal formacao_alcancou_o_chao

## Emitido a cada bandido abatido, para a fase somar os pontos.
signal bandido_abatido(pontos: int)

@export var cena_do_bandido: PackedScene
@export var colunas: int = 9
@export var linhas: int = 4

## Distância entre os cantos de dois bandidos vizinhos, em pixels.
@export var espacamento: Vector2 = Vector2(16, 14)

## Quantos pixels a formação anda a cada passo.
@export var passo_horizontal: float = 4.0

## Quantos pixels desce ao encostar na borda.
@export var passo_vertical: float = 8.0

## Intervalo entre passos, em segundos. Diminui conforme os bandidos caem.
@export var intervalo_inicial: float = 0.6

## Intervalo mínimo, para a formação não ficar rápida demais no fim.
@export var intervalo_minimo: float = 0.12

## Altura em que a formação é considerada no chão.
@export var altura_limite: float = 180.0

var _sentido := 1
var _pose := 0
var _tempo_ate_o_proximo_passo := 0.0
var _total_inicial := 0


func _ready() -> void:
	_montar_grade()
	_tempo_ate_o_proximo_passo = intervalo_inicial


func _process(delta: float) -> void:
	_tempo_ate_o_proximo_passo -= delta
	if _tempo_ate_o_proximo_passo > 0.0:
		return
	_dar_um_passo()
	_tempo_ate_o_proximo_passo = _intervalo_atual()


## Cria os bandidos em grade, posicionados em relação a este nó.
func _montar_grade() -> void:
	if cena_do_bandido == null:
		push_warning("Formação: nenhuma cena de bandido atribuída no Inspector.")
		return
	for linha in linhas:
		for coluna in colunas:
			var bandido := cena_do_bandido.instantiate()
			bandido.position = Vector2(coluna * espacamento.x, linha * espacamento.y)
			bandido.abatido.connect(_ao_abater_bandido)
			add_child(bandido)
	_total_inicial = get_child_count()


## Move a formação um passo e alterna a pose de todos.
func _dar_um_passo() -> void:
	if _vai_ultrapassar_a_borda():
		_sentido *= -1
		position.y += passo_vertical
		if position.y >= altura_limite:
			formacao_alcancou_o_chao.emit()
	else:
		position.x += passo_horizontal * _sentido

	_pose = 1 - _pose
	for bandido in get_children():
		bandido.trocar_pose(_pose)


## Verifica se o próximo passo colocaria algum bandido fora da tela.
func _vai_ultrapassar_a_borda() -> bool:
	var bandidos := get_children()
	if bandidos.is_empty():
		return false

	var menor_x := INF
	var maior_x := -INF
	for bandido in bandidos:
		menor_x = minf(menor_x, bandido.global_position.x)
		maior_x = maxf(maior_x, bandido.global_position.x)

	var largura_tela := get_viewport_rect().size.x
	var proximo_menor := menor_x + passo_horizontal * _sentido
	var proximo_maior := maior_x + passo_horizontal * _sentido
	return proximo_menor < 8.0 or proximo_maior > largura_tela - 8.0


## Quanto mais bandidos caem, mais rápido avançam os que restam.
func _intervalo_atual() -> float:
	if _total_inicial == 0:
		return intervalo_inicial
	var proporcao_viva := float(get_child_count()) / float(_total_inicial)
	return maxf(intervalo_inicial * proporcao_viva, intervalo_minimo)


func _ao_abater_bandido(pontos: int) -> void:
	bandido_abatido.emit(pontos)
	# O nó ainda existe neste quadro; espera a remoção antes de contar.
	await get_tree().process_frame
	if get_child_count() == 0:
		formacao_derrotada.emit()
