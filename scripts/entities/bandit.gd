extends Area2D

## Um bandido da formação.
##
## Não se move por conta própria: quem anda é a formação inteira, para que
## todos avancem no mesmo passo. Aqui ficam apenas o valor em pontos e a morte.

## Emitido ao ser abatido, para a formação saber que perdeu um integrante.
signal abatido(pontos: int)

## Quanto vale ao ser derrubado.
@export var pontos: int = 10

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D


## Chamado pela formação a cada passo, para todos trocarem de pose juntos.
func trocar_pose(indice: int) -> void:
	_sprite.frame = indice


func levar_tiro() -> void:
	abatido.emit(pontos)
	queue_free()
