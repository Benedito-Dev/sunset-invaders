extends Control

## Tela de vitória.
##
## Mesma mecânica da derrota: a pontuação vem de `SceneManager.ultima_pontuacao`.

@onready var _rotulo_pontuacao: Label = $ScoreLabel


func _ready() -> void:
	if _rotulo_pontuacao:
		_rotulo_pontuacao.text = "PONTUACAO: %d" % SceneManager.ultima_pontuacao


func _ao_apertar_jogar_de_novo() -> void:
	SceneManager.ir_para_fase()


func _ao_apertar_menu() -> void:
	SceneManager.ir_para_inicio()
