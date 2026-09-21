class_name GamePaths
extends RefCounted

## Caminhos das cenas de tela, num lugar só.
##
## Centralizar aqui evita string solta espalhada pelo código: se uma cena mudar
## de lugar, só esta lista precisa acompanhar.

const TITLE := "res://scenes/screens/title.tscn"
const GAME := "res://scenes/screens/game.tscn"
const GAME_OVER := "res://scenes/screens/game_over.tscn"
const VICTORY := "res://scenes/screens/victory.tscn"
