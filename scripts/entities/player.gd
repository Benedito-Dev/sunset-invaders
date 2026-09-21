extends CharacterBody2D

## O xerife. Move-se na horizontal, preso aos limites da tela, e atira para cima.

## Velocidade horizontal, em pixels por segundo.
@export var velocidade: float = 80.0

## Tempo mínimo entre dois tiros, em segundos.
@export var intervalo_entre_tiros: float = 0.35

## Cena instanciada a cada disparo.
@export var cena_da_bala: PackedScene

## Metade da largura do sprite, para o xerife não sair pela borda.
@onready var _meia_largura: float = $Sprite2D.texture.get_width() / 2.0

## De onde a bala nasce: logo acima do chapéu.
@onready var _ponto_de_tiro: Marker2D = $Spawn_Bullet

var _tempo_ate_poder_atirar := 0.0


func _physics_process(delta: float) -> void:
	_mover(delta)
	_processar_tiro(delta)


func _mover(_delta: float) -> void:
	var direcao := Input.get_axis("move_left", "move_right")
	velocity.x = direcao * velocidade
	velocity.y = 0.0
	move_and_slide()
	_limitar_a_tela()


## Impede que o xerife ultrapasse as bordas laterais.
func _limitar_a_tela() -> void:
	var largura_tela := get_viewport_rect().size.x
	position.x = clampf(position.x, _meia_largura, largura_tela - _meia_largura)


## Dispara respeitando a cadência, enquanto a ação estiver pressionada.
func _processar_tiro(delta: float) -> void:
	_tempo_ate_poder_atirar = maxf(_tempo_ate_poder_atirar - delta, 0.0)
	if not Input.is_action_pressed("shoot"):
		return
	if _tempo_ate_poder_atirar > 0.0:
		return
	_atirar()
	_tempo_ate_poder_atirar = intervalo_entre_tiros


func _atirar() -> void:
	if cena_da_bala == null:
		push_warning("Player: nenhuma cena de bala atribuída no Inspector.")
		return
	var bala := cena_da_bala.instantiate()
	# A bala entra na fase, não no xerife: assim ela não se move junto com ele.
	get_parent().add_child(bala)
	bala.global_position = _ponto_de_tiro.global_position
