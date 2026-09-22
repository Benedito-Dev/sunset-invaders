extends Area2D

## Projétil. Viaja em linha reta e se destrói ao sair da tela ou ao acertar
## um alvo válido.
##
## A mesma cena serve ao xerife e aos bandidos: quem dispara define a direção
## e o grupo que o tiro procura.

## Velocidade, em pixels por segundo.
@export var velocidade: float = 150.0

## Para onde a bala viaja. Vector2.UP sobe, Vector2.DOWN desce.
@export var direcao: Vector2 = Vector2.UP

## Sprite da bala
@onready var Sprite: AnimatedSprite2D = $AnimatedSprite2D

## Grupo que este tiro acerta. Impede que bala inimiga atinja outro inimigo.
var grupo_alvo: StringName = &""


func _ready() -> void:
	area_entered.connect(_ao_encostar_em)
	# A arte aponta para cima; descendo, o sprite é espelhado na vertical.
	Sprite.flip_v = direcao.y > 0
	Sprite.play("default")


func _physics_process(delta: float) -> void:
	position += velocidade * delta * direcao


func _ao_encostar_em(area: Area2D) -> void:
	if not area.has_method("levar_tiro"):
		return
	# A barreira consome qualquer tiro, venha de quem vier.
	var e_barreira := area.is_in_group(&"barreiras")
	if not e_barreira and grupo_alvo != &"" and not area.is_in_group(grupo_alvo):
		return
	area.levar_tiro()
	_desaparecer()


## Emitido pelo VisibleOnScreenNotifier2D quando a bala deixa a tela.
func _ao_sair_da_tela() -> void:
	_desaparecer()


## Sai de cena sem cortar o som do disparo, caso ele ainda esteja tocando.
func _desaparecer() -> void:
	var som: AudioStreamPlayer = $SomDoTiro
	if not som.playing:
		queue_free()
		return
	# Solta o som na cena para que termine sozinho, e some com o resto.
	hide()
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	await som.finished
	queue_free()
