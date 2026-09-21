extends Control

## Tela de início. Confirmar leva à fase principal.
##
## `ui_accept` já vem mapeado pelo Godot em Enter, Espaço e no botão de ação
## do controle, então não é preciso registrar nada no Input Map.

## Quantas vezes o rótulo apaga e acende antes da troca de cena.
const PISCADAS := 4

## Duração de cada apagar-acender, em segundos.
const INTERVALO_PISCADA := 0.08

@onready var _rotulo: Label = $Label
@onready var _som_de_start: AudioStreamPlayer = $SomDeStart

var _confirmado := false


func _unhandled_input(event: InputEvent) -> void:
	if _confirmado or not event.is_action_pressed("ui_accept"):
		return
	_confirmado = true
	get_viewport().set_input_as_handled()
	_som_de_start.play()
	_piscar_e_comecar()


## Pisca o rótulo como confirmação e só então troca de cena.
func _piscar_e_comecar() -> void:
	var tween := create_tween()
	for i in PISCADAS:
		tween.tween_callback(_mostrar_rotulo.bind(false))
		tween.tween_interval(INTERVALO_PISCADA)
		tween.tween_callback(_mostrar_rotulo.bind(true))
		tween.tween_interval(INTERVALO_PISCADA)
	await tween.finished
	# Deixa o som terminar antes de trocar de cena, para não cortá-lo.
	if _som_de_start.playing:
		await _som_de_start.finished
	SceneManager.ir_para_fase()


func _mostrar_rotulo(visivel: bool) -> void:
	_rotulo.visible = visivel
