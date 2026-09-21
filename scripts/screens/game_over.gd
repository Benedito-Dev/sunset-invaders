extends Control

## Tela de derrota.
##
## A pontuação da partida chega por `SceneManager.ultima_pontuacao` — a cena
## anterior já foi descarregada quando esta monta, então o valor vem do autoload.

@onready var _rotulo_pontuacao: Label = $ScoreLabel


func _ready() -> void:
	if _rotulo_pontuacao:
		_rotulo_pontuacao.text = "PONTUACAO: %d" % SceneManager.ultima_pontuacao


func _ao_apertar_tentar_de_novo() -> void:
	SceneManager.ir_para_fase()


func _ao_apertar_menu() -> void:
	SceneManager.ir_para_inicio()
