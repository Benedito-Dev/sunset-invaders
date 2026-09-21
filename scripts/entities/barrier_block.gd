extends Area2D

## Um pedaço de barreira.
##
## Some ao ser atingido, abrindo passagem para os tiros seguintes. Vários
## blocos lado a lado formam uma barreira inteira.


func _ready() -> void:
	add_to_group(&"barreiras")


func levar_tiro() -> void:
	queue_free()
