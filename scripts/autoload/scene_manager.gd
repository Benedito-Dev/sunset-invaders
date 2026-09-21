extends CanvasLayer

## Troca de telas com transição em fade.
##
## Registrado como autoload (Project → Project Settings → Autoload), portanto
## acessível de qualquer script como `SceneManager`. Como é um CanvasLayer com
## camada alta, o retângulo de fade cobre tudo o que estiver na tela.
##
## Uso:
##     SceneManager.goto_game()
##     SceneManager.goto_game_over(score)
##     SceneManager.goto_victory(score)
##     SceneManager.goto_title()

## Emitido quando a nova cena já está ativa e o fade-in terminou.
signal transition_finished

const START_SCREEN := "res://scenes/screens/start_screen.tscn"
const MAIN_PHASE := "res://scenes/screens/main_phase.tscn"
const GAME_OVER := "res://scenes/screens/game_over.tscn"
const VICTORY := "res://scenes/screens/victory.tscn"

const FADE_DURATION := 0.3

## Pontuação da última partida, lida pelas telas de fim de jogo.
var last_score: int = 0

var _fade: ColorRect
var _is_transitioning := false


func _ready() -> void:
	layer = 128
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_fade_rect()


## Cria o retângulo preto que cobre a tela durante a troca.
func _build_fade_rect() -> void:
	_fade = ColorRect.new()
	_fade.color = Color.BLACK
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade.modulate.a = 0.0
	_fade.visible = false
	add_child(_fade)


func goto_start_screen() -> void:
	_change_scene(START_SCREEN)


func goto_game() -> void:
	last_score = 0
	_change_scene(MAIN_PHASE)


func goto_game_over(score: int = 0) -> void:
	last_score = score
	_change_scene(GAME_OVER)


func goto_victory(score: int = 0) -> void:
	last_score = score
	_change_scene(VICTORY)


## Fade out → troca a cena → fade in.
func _change_scene(path: String) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true

	await _fade_to(1.0)

	var error := get_tree().change_scene_to_file(path)
	if error != OK:
		push_error("SceneManager: falha ao carregar '%s' (erro %d)" % [path, error])

	# Espera o fim do frame para a nova cena montar antes de revelá-la.
	await get_tree().process_frame

	await _fade_to(0.0)

	_is_transitioning = false
	transition_finished.emit()


func _fade_to(target_alpha: float) -> void:
	_fade.visible = true
	var tween := create_tween()
	tween.tween_property(_fade, "modulate:a", target_alpha, FADE_DURATION)
	await tween.finished
	_fade.visible = target_alpha > 0.0
