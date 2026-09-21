extends CharacterBody2D

## O xerife. Move-se apenas na horizontal, preso aos limites da tela.

## Velocidade horizontal, em pixels por segundo.
@export var speed: float = 80.0

## Metade da largura do sprite, usada para o xerife não sair pela borda.
@onready var _half_width: float = $Sprite2D.texture.get_width() / 2.0


func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	velocity.y = 0.0
	move_and_slide()
	_clamp_to_screen()


## Impede que o xerife ultrapasse as bordas laterais da tela.
func _clamp_to_screen() -> void:
	var screen_width := get_viewport_rect().size.x
	position.x = clampf(position.x, _half_width, screen_width - _half_width)
