extends Control

## Tela de título. Primeira cena carregada ao abrir o jogo.
##
## Ligue o `pressed` dos botões a estes métodos pelo painel Node do editor,
## ou deixe o `_unhandled_input` cuidar do "aperte qualquer tecla".


func _on_play_pressed() -> void:
	SceneManager.goto_game()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_on_play_pressed()
