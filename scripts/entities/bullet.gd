extends Area2D

## Projétil do xerife. Sobe em linha reta e se destrói ao sair da tela
## ou ao acertar um bandido.

## Velocidade vertical, em pixels por segundo. Sobe, então subtrai de y.
@export var velocidade: float = 90.0


func _ready() -> void:
	area_entered.connect(_ao_encostar_em)


func _physics_process(delta: float) -> void:
	position.y -= velocidade * delta


## A bala encosta em qualquer Area2D; só o bandido sabe levar tiro.
func _ao_encostar_em(area: Area2D) -> void:
	if not area.has_method("levar_tiro"):
		return
	area.levar_tiro()
	queue_free()


## Emitido pelo VisibleOnScreenNotifier2D quando a bala deixa a tela.
func _ao_sair_da_tela() -> void:
	queue_free()
