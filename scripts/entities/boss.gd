extends Area2D

## O chefe. Entra pela lateral, faz uma pausa no centro e passa a patrulhar.

# ── Os três momentos do boss ──────────────────────────────
enum Estado { ENTRANDO, PARADO, PATRULHANDO }

## Emitido quando a entrada termina e a patrulha começa.
signal patrulha_iniciada

## Vida
@export var life: int = 30
@onready var _vida_maxima: int = life

@export var duracao_do_pisca: float = 0.12

## Cena instanciada quando este bandido atira.
@export var cena_da_bala: PackedScene

#Spawn Da bala
@onready var _ponto_de_tiro: Marker2D = $Spawn_Bullet

#Velocidade do boss
@export var velocidade: float = 40.0

## Quanto tempo ele fica imóvel no centro antes de começar a patrulhar.
@export var pausa_ao_chegar: float = 2

# Intervalo de Disparo
@export var intervalo_entre_tiros: float = 0.8
var _tempo_ate_o_proximo_tiro := 0.0

@onready var Boss_Sprite: AnimatedSprite2D = $Sprite
@onready var _centro: float = get_viewport_rect().size.x / 2.0

## Metade da largura dele, para saber quando encostou na parede.
@onready var _meia_largura: float = $CollisionShape2D.shape.size.x / 1.8

## Limites de Altura
@export var altura_minima: float = 20.0
@export var altura_maxima: float = 100.0

## Em qual dos três momentos ele está agora.
var _estado := Estado.ENTRANDO

## 1 anda para a direita, -1 para a esquerda. Usado só na patrulha.
var _direcao := Vector2.RIGHT

func _ready() -> void:
	add_to_group(&"inimigos")
	add_to_group(&"boss")
	Boss_Sprite.play("default")
	
func _process(delta: float) -> void:
	if _estado == Estado.ENTRANDO:
		_avancar_para_o_centro(delta)
	elif _estado == Estado.PATRULHANDO:
		_patrulhar(delta)


# ── Momento 1: entrar ─────────────────────────────────────
func _avancar_para_o_centro(delta: float) -> void:
	position.x += velocidade * delta
	if position.x < _centro:
		return
	_fazer_a_pausa()

# ── Momento 2: parar ──────────────────────────────────────
# Esta função tem await, por isso mora fora do _process: ela é chamada uma
# vez só, enquanto o _process roda a cada quadro.
func _fazer_a_pausa() -> void:
	_estado = Estado.PARADO
	Boss_Sprite.pause()
	Boss_Sprite.play("entrada")

	# Espera sem travar o jogo: o resto continua rodando normalmente.
	await get_tree().create_timer(pausa_ao_chegar).timeout

	_estado = Estado.PATRULHANDO
	Boss_Sprite.play("default")
	patrulha_iniciada.emit()

# ── Momento 3: patrulhar ──────────────────────────────────
func _patrulhar(delta: float) -> void:
	position += _direcao  * velocidade * delta
	_tempo_ate_o_proximo_tiro -= delta
	if _tempo_ate_o_proximo_tiro <= 0.0:
		atirar()
		_tempo_ate_o_proximo_tiro = intervalo_entre_tiros
	
	var largura_tela := get_viewport_rect().size.x
	var limite_esquerdo := _meia_largura
	var limite_direito := largura_tela - _meia_largura
	
	# Encostou à direita
	if position.x >= limite_direito:
		position.x = limite_direito
		_ricochetear_com_desvio()
		Boss_Sprite.flip_h = true
		
	# Encostou à esquerda: o contrário.
	elif position.x <= limite_esquerdo:
		position.x = limite_esquerdo
		_ricochetear_com_desvio()
		Boss_Sprite.flip_h = false
		
	if position.y <= altura_minima:
		position.y = altura_minima
		_direcao.y = -_direcao.y
	elif position.y >= altura_maxima:
		position.y = altura_maxima
		_direcao.y = -_direcao.y

## Inverte a direção horizontal e desvia o resultado num ângulo aleatório.
func _ricochetear_com_desvio() -> void:
	var angulo := deg_to_rad(randf_range(-45.0, 45.0))
	var lado := -signf(_direcao.x)
	_direcao = Vector2(lado, 0.0).rotated(angulo)

# ── Disparo ──────────────────────────────────
func atirar() -> void:
	if cena_da_bala == null:
		return
	var bala := cena_da_bala.instantiate()
	bala.direcao = 1
	bala.velocidade = 300
	bala.grupo_alvo = &"jogador"
	# A bala entra na fase, para não acompanhar o movimento da formação.
	get_tree().current_scene.add_child(bala)
	bala.global_position = _ponto_de_tiro.global_position
	
	
# ── Piscar ──────────────────────────────────
func _piscar() -> void:
	Boss_Sprite.animation = &"so_cavalo"
	await get_tree().create_timer(duracao_do_pisca).timeout
	if life >= _vida_maxima * 0.30:
		Boss_Sprite.animation = &"default"
	else:
		Boss_Sprite.animation = &"low_life"
	
# ── Levar tiro ──────────────────────────────────
func levar_tiro() -> void:
	life -= 1
	if life <= _vida_maxima * 0.30:
		Boss_Sprite.play("low_life")
	if life <= 0:
		queue_free()
		return
	_piscar()
