extends Area2D

## Projétil do xerife. Sobe em linha reta e se destrói ao sair da tela.

## Velocidade vertical, em pixels por segundo. Negativa porque sobe.
@export var velocidade: float = 180.0


func _physics_process(delta: float) -> void:
	position.y -= velocidade * delta


## Emitido pelo VisibleOnScreenNotifier2D quando a bala deixa a tela.
func _ao_sair_da_tela() -> void:
	queue_free()
