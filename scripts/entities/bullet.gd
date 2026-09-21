extends Area2D

## Projétil. Viaja em linha reta e se destrói ao sair da tela ou ao acertar
## um alvo válido.
##
## A mesma cena serve ao xerife e aos bandidos: quem dispara define a direção
## e o grupo que o tiro procura.

## Velocidade, em pixels por segundo.
@export var velocidade: float = 90.0

## -1 sobe (tiro do xerife), 1 desce (tiro do bandido).
@export var direcao: int = -1

## Grupo que este tiro acerta. Impede que bala inimiga atinja outro inimigo.
var grupo_alvo: StringName = &""


func _ready() -> void:
	area_entered.connect(_ao_encostar_em)
	# A arte aponta para cima; descendo, o sprite é espelhado na vertical.
	$Sprite2D.flip_v = direcao > 0


func _physics_process(delta: float) -> void:
	position.y += velocidade * delta * direcao


func _ao_encostar_em(area: Area2D) -> void:
	if not area.has_method("levar_tiro"):
		return
	# A barreira consome qualquer tiro, venha de quem vier.
	var e_barreira := area.is_in_group(&"barreiras")
	if not e_barreira and grupo_alvo != &"" and not area.is_in_group(grupo_alvo):
		return
	area.levar_tiro()
	queue_free()


## Emitido pelo VisibleOnScreenNotifier2D quando a bala deixa a tela.
func _ao_sair_da_tela() -> void:
	queue_free()
