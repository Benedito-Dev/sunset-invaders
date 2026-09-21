extends Control

## Tela de derrota.
##
## A pontuação da partida chega por `SceneManager.ultima_pontuacao` — a cena
## anterior já foi descarregada quando esta monta, então o valor vem do autoload.

const PISCADAS = 4
const INTERVALO_PISCADA := 0.08
var pressionado := false

@onready var _rotulo_pontuacao: Label = $ScoreLabel
@onready var Restart: Label = $Background/Restart


func _ready() -> void:
	if _rotulo_pontuacao:
		_rotulo_pontuacao.text = "PONTUACAO: %d" % SceneManager.ultima_pontuacao


func _unhandled_input(event: InputEvent) -> void:
	if pressionado or not event.is_action_pressed("ui_accept"):
		return
	pressionado = true
	_piscar_e_recomecar()
	
## Pisca o rótulo como confirmação e só então troca de cena.
func _piscar_e_recomecar() -> void:
	var tween := create_tween()
	for i in PISCADAS:
		tween.tween_callback(_mostrar_rotulo.bind(false))
		tween.tween_interval(INTERVALO_PISCADA)
		tween.tween_callback(_mostrar_rotulo.bind(true))
		tween.tween_interval(INTERVALO_PISCADA)
	await tween.finished
	SceneManager.ir_para_fase()

func _mostrar_rotulo(visivel: bool) -> void:
	Restart.visible = visivel

func _ao_apertar_menu() -> void:
	SceneManager.ir_para_inicio()
