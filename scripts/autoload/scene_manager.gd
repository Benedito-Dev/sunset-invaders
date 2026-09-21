extends CanvasLayer

## Troca de telas com transição em escurecimento.
##
## Registrado como autoload (Project → Project Settings → Autoload), portanto
## acessível de qualquer script como `SceneManager`. Como é um CanvasLayer em
## camada alta, o retângulo de escurecimento cobre tudo o que estiver na tela.
##
## Uso:
##     SceneManager.ir_para_fase()
##     SceneManager.ir_para_derrota(pontuacao)
##     SceneManager.ir_para_vitoria(pontuacao)
##     SceneManager.ir_para_inicio()

## Emitido quando a nova cena já está ativa e a tela voltou a clarear.
signal transicao_concluida

const TELA_INICIO := "res://scenes/screens/start_screen.tscn"
const FASE_PRINCIPAL := "res://scenes/screens/main_phase.tscn"
const TELA_DERROTA := "res://scenes/screens/game_over.tscn"
const TELA_VITORIA := "res://scenes/screens/victory.tscn"

## Quanto tempo leva para escurecer ou clarear, em segundos.
const DURACAO_TRANSICAO := 0.3

## Pontuação da última partida, lida pelas telas de fim de jogo.
var ultima_pontuacao: int = 0

var _cortina: ColorRect
var _em_transicao := false


func _ready() -> void:
	layer = 128
	process_mode = Node.PROCESS_MODE_ALWAYS
	_criar_cortina()


## F11 alterna tela cheia em qualquer tela do jogo.
func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("toggle_fullscreen"):
		return
	var em_tela_cheia := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_WINDOWED if em_tela_cheia
		else DisplayServer.WINDOW_MODE_FULLSCREEN
	)
	get_viewport().set_input_as_handled()


## Cria o retângulo preto que cobre a tela durante a troca.
func _criar_cortina() -> void:
	_cortina = ColorRect.new()
	_cortina.color = Color.BLACK
	_cortina.set_anchors_preset(Control.PRESET_FULL_RECT)
	_cortina.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cortina.modulate.a = 0.0
	_cortina.visible = false
	add_child(_cortina)


func ir_para_inicio() -> void:
	_trocar_cena(TELA_INICIO)


func ir_para_fase() -> void:
	ultima_pontuacao = 0
	_trocar_cena(FASE_PRINCIPAL)


func ir_para_derrota(pontuacao: int = 0) -> void:
	ultima_pontuacao = pontuacao
	_trocar_cena(TELA_DERROTA)


func ir_para_vitoria(pontuacao: int = 0) -> void:
	ultima_pontuacao = pontuacao
	_trocar_cena(TELA_VITORIA)


## Escurece a tela, troca a cena e clareia de volta.
func _trocar_cena(caminho: String) -> void:
	if _em_transicao:
		return
	_em_transicao = true

	await _ajustar_cortina(1.0)

	var erro := get_tree().change_scene_to_file(caminho)
	if erro != OK:
		push_error("SceneManager: falha ao carregar '%s' (erro %d)" % [caminho, erro])

	# Espera o fim do quadro para a nova cena montar antes de revelá-la.
	await get_tree().process_frame

	await _ajustar_cortina(0.0)

	_em_transicao = false
	transicao_concluida.emit()


func _ajustar_cortina(opacidade_final: float) -> void:
	_cortina.visible = true
	var tween := create_tween()
	tween.tween_property(_cortina, "modulate:a", opacidade_final, DURACAO_TRANSICAO)
	await tween.finished
	_cortina.visible = opacidade_final > 0.0
