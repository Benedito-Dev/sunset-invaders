extends Area2D

## Um bandido da formação.
##
## Não se move por conta própria: quem anda é a formação inteira, para que
## todos avancem no mesmo passo. Aqui ficam o valor em pontos, o disparo e
## a morte.

## Emitido ao ser abatido, para a formação saber que perdeu um integrante.
signal abatido(pontos: int)

## Quanto vale ao ser derrubado.
@export var pontos: int = 10

## Cena instanciada quando este bandido atira.
@export var cena_da_bala: PackedScene

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _ponto_de_tiro: Marker2D = $Spawn_Bullet


func _ready() -> void:
	add_to_group(&"inimigos")


## Chamado pela formação, para todos encararem o mesmo lado.
func trocar_pose(indice: int) -> void:
	_sprite.frame = indice


## Chamado pela formação quando este bandido é sorteado para disparar.
func atirar() -> void:
	if cena_da_bala == null:
		return
	var bala := cena_da_bala.instantiate()
	bala.direcao = Vector2.DOWN
	bala.grupo_alvo = &"jogador"
	# A bala entra na fase, para não acompanhar o movimento da formação.
	get_tree().current_scene.add_child(bala)
	bala.global_position = _ponto_de_tiro.global_position


func levar_tiro() -> void:
	abatido.emit(pontos)
	queue_free()
