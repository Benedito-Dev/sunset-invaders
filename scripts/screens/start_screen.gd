extends Control

## Tela de início. Confirmar leva à fase principal.
##
## `ui_accept` já vem mapeado pelo Godot em Enter, Espaço e no botão de ação
## do controle, então não é preciso registrar nada no Input Map.

## Quantas vezes o rótulo apaga e acende antes da troca de cena.
const BLINK_COUNT := 4

## Duração de cada apagar-acender, em segundos.
const BLINK_STEP := 0.08

@onready var _label: Label = $Label

var _confirmed := false


func _unhandled_input(event: InputEvent) -> void:
	if _confirmed or not event.is_action_pressed("ui_accept"):
		return
	_confirmed = true
	get_viewport().set_input_as_handled()
	_blink_then_start()


## Pisca o rótulo como confirmação e só então troca de cena.
func _blink_then_start() -> void:
	var tween := create_tween()
	for i in BLINK_COUNT:
		tween.tween_callback(_set_label_visible.bind(false))
		tween.tween_interval(BLINK_STEP)
		tween.tween_callback(_set_label_visible.bind(true))
		tween.tween_interval(BLINK_STEP)
	await tween.finished
	SceneManager.goto_game()


func _set_label_visible(is_visible: bool) -> void:
	_label.visible = is_visible
