extends Area2D

## Um pedaço de barreira.
##
## Some ao ser atingido, abrindo passagem para os tiros seguintes. Vários
## blocos lado a lado formam uma barreira inteira.
var vida: int = 2
@onready var Barreira: Sprite2D = $Barreira

func _ready() -> void:
	add_to_group(&"barreiras")


func levar_tiro() -> void:
	vida -=1
	if vida > 0:
		Barreira.frame = 1
	else:
		queue_free()
