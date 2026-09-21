extends Control

## Tela de início. Qualquer confirmação leva à fase principal.
##
## `ui_accept` já vem mapeado pelo Godot em Enter, Espaço e no botão de ação
## do controle, então não é preciso registrar nada no Input Map.


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		SceneManager.goto_game()
