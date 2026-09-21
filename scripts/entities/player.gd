extends CharacterBody2D

## O xerife. Move-se apenas na horizontal, preso aos limites da tela.

## Velocidade horizontal, em pixels por segundo.
@export var velocidade: float = 80.0

## Metade da largura do sprite, para o xerife não sair pela borda.
@onready var _meia_largura: float = $Sprite2D.texture.get_width() / 2.0


func _physics_process(_delta: float) -> void:
	var direcao := Input.get_axis("move_left", "move_right")
	velocity.x = direcao * velocidade
	velocity.y = 0.0
	move_and_slide()
	_limitar_a_tela()


## Impede que o xerife ultrapasse as bordas laterais.
func _limitar_a_tela() -> void:
	var largura_tela := get_viewport_rect().size.x
	position.x = clampf(position.x, _meia_largura, largura_tela - _meia_largura)
