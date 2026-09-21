extends Node2D

## A formação de bandidos.
##
## Monta a grade e move todos juntos: avança na horizontal até alguém encostar
## na borda, então desce um degrau e inverte o sentido. Os bandidos encaram o
## lado para onde a formação caminha.
##
## Cada passo é um saltinho: a formação salta ao ápice, faz uma breve pausa no
## ar e cai no destino, em vez de escorregar até ele.

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

## Quanto o salto sobe no meio do passo, em pixels.
@export var altura_do_salto: float = 4.0

## Quanto tempo a formação fica suspensa no ápice, em segundos.
@export var tempo_no_apice: float = 0.1

## Índices dos quadros de pose no AnimatedSprite2D do bandido.
const POSE_ESQUERDA := 0
const POSE_DIREITA := 1

var _sentido := 1
var _tempo_ate_o_proximo_passo := 0.0
var _total_inicial := 0

## Onde a formação pousa ao fim do salto em curso.
var _pouso := Vector2.ZERO


func _ready() -> void:
	_montar_grade()
	_encarar_o_sentido()
	_pouso = position
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


## Move a formação um passo. Ao virar, todos passam a encarar o novo lado.
func _dar_um_passo() -> void:
	if _vai_ultrapassar_a_borda():
		_sentido *= -1
		_saltar_para(Vector2(_pouso.x, _pouso.y + passo_vertical))
		_encarar_o_sentido()
		if _pouso.y >= altura_limite:
			formacao_alcancou_o_chao.emit()
	else:
		_saltar_para(Vector2(_pouso.x + passo_horizontal * _sentido, _pouso.y))


## Salta até o destino passando pelo ápice, com uma pausa breve no ar.
func _saltar_para(destino: Vector2) -> void:
	_pouso = destino
	var apice := Vector2(
		(position.x + destino.x) / 2.0,
		minf(position.y, destino.y) - altura_do_salto
	)
	position = apice
	await get_tree().create_timer(tempo_no_apice).timeout
	# A formação pode ter sido liberada durante a espera.
	if is_inside_tree():
		position = destino


## Aponta todos os bandidos para o lado em que a formação caminha.
func _encarar_o_sentido() -> void:
	var pose := POSE_DIREITA if _sentido > 0 else POSE_ESQUERDA
	for bandido in get_children():
		bandido.trocar_pose(pose)


## Verifica se o próximo passo colocaria algum bandido fora da tela.
func _vai_ultrapassar_a_borda() -> bool:
	var bandidos := get_children()
	if bandidos.is_empty():
		return false

	# Durante o salto a formação está no ápice; mede a partir do pouso.
	var deslocamento := _pouso.x - position.x
	var menor_x := INF
	var maior_x := -INF
	for bandido in bandidos:
		var x := bandido.global_position.x + deslocamento
		menor_x = minf(menor_x, x)
		maior_x = maxf(maior_x, x)

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
