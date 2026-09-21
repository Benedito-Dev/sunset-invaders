extends Node2D

## A linha de barreiras entre o xerife e os bandidos.
##
## Monta as barreiras por código, cada uma como uma grade de blocos. Os blocos
## somem um a um conforme apanham, abrindo buracos por onde os tiros passam.

@export var cena_do_bloco: PackedScene

## Quantas barreiras distribuir na largura da tela.
@export var quantidade: int = 4

## Quantos blocos formam cada barreira.
@export var blocos_por_barreira: Vector2i = Vector2i(8, 8)

## Tamanho de um bloco, em pixels. Precisa bater com a arte.
@export var tamanho_do_bloco: Vector2 = Vector2(4, 2)


func _ready() -> void:
	_montar_barreiras()


## Distribui as barreiras com folga igual entre elas e nas laterais.
func _montar_barreiras() -> void:
	if cena_do_bloco == null:
		push_warning("Barreiras: nenhuma cena de bloco atribuída no Inspector.")
		return

	var largura_barreira := blocos_por_barreira.x * tamanho_do_bloco.x
	var largura_tela := get_viewport_rect().size.x
	var folga := (largura_tela - quantidade * largura_barreira) / (quantidade + 1)

	for indice in quantidade:
		var inicio := folga + indice * (largura_barreira + folga)
		_montar_uma_barreira(inicio)


## Cria a grade de blocos de uma barreira, a partir da borda esquerda dela.
func _montar_uma_barreira(inicio_x: float) -> void:
	for linha in blocos_por_barreira.y:
		for coluna in blocos_por_barreira.x:
			var bloco := cena_do_bloco.instantiate()
			bloco.position = Vector2(
				inicio_x + coluna * tamanho_do_bloco.x,
				linha * tamanho_do_bloco.y
			)
			add_child(bloco)
