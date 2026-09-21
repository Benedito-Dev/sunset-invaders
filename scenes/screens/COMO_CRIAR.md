# Trilha: criando as quatro telas

Os scripts já existem em `scripts/screens/`. Falta criar as cenas e amarrá-las.
Siga na ordem — cada passo deixa algo testável.

> **Antes de tudo:** o projeto aponta `main_scene` para `title.tscn`, que ainda
> não existe. Rodar o jogo (F5) só funciona depois do passo 1.

---

## 1. `title.tscn` — a tela de título

1. `Scene → New Scene → User Interface` (cria um nó `Control`).
2. Renomeie a raiz para **`Title`** e salve como
   `scenes/screens/title.tscn`.
3. No Inspector da raiz, em *Layout → Anchors Preset*, escolha **Full Rect**.
4. Adicione `TextureRect` como filho, nomeie **`Background`**:
   - *Texture*: arraste `assets/sprites/ui/title-screen.png`
   - *Expand Mode*: `Ignore Size` · *Stretch Mode*: `Keep Aspect Centered`
   - *Layout → Anchors Preset*: **Full Rect**
5. Adicione um `VBoxContainer` chamado **`Menu`**, centralizado, e dentro dele
   dois `Button`: **`PlayButton`** ("JOGAR") e **`QuitButton`** ("SAIR").
6. Selecione a raiz `Title` → aba **Script** → anexe
   `scripts/screens/title.gd` (use *Load*, não *New*).
7. Selecione `PlayButton` → painel **Node → Signals** → duplo clique em
   `pressed()` → conecte ao método `_on_play_pressed`. Repita para
   `QuitButton` → `_on_quit_pressed`.

✅ **Teste:** F5. A tela aparece e "SAIR" fecha o jogo. "JOGAR" ainda dá erro —
`game.tscn` não existe.

---

## 2. `game.tscn` — a fase

1. `Scene → New Scene → 2D Scene` (nó `Node2D`).
2. Renomeie a raiz para **`Game`**, salve como `scenes/screens/game.tscn` e
   anexe `scripts/screens/game.gd`.
3. Estruture os filhos assim — separar agora evita bagunça depois:

```
Game
├── Background      (Sprite2D ou ColorRect com o degradê do pôr do sol)
├── Player          (instância de scenes/entities/player.tscn)
├── Enemies         (Node2D vazio — recebe os bandidos instanciados)
├── Bullets         (Node2D vazio — recebe os projéteis)
├── Cover           (Node2D vazio — recebe os barris)
└── HUD             (CanvasLayer com pontuação e munição)
```

> Os `Node2D` vazios são contêineres. Ter um pai por categoria deixa você
> limpar a tela (`for b in $Bullets.get_children(): b.queue_free()`) e contar
> inimigos vivos (`$Enemies.get_child_count()`) sem varrer a cena inteira.

4. Para testar a navegação antes de existir jogabilidade, adicione
   temporariamente em `game.gd`:

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):     # Esc
		end_in_defeat()
	if event.is_action_pressed("ui_accept"):     # Enter
		end_in_victory()
```

✅ **Teste:** F5 → JOGAR leva à fase.

---

## 3. `game_over.tscn` e `victory.tscn`

As duas são gêmeas; faça uma e duplique.

1. `Scene → New Scene → User Interface`, raiz **`GameOver`**, salve como
   `scenes/screens/game_over.tscn`, anexe `scripts/screens/game_over.gd`.
2. Filhos:
   - `Label` **`TitleLabel`** — "FIM DE JOGO"
   - `Label` **`ScoreLabel`** — deixe o texto vazio, o script preenche
   - `Button` **`RetryButton`** — "JOGAR DE NOVO"
   - `Button` **`TitleButton`** — "MENU PRINCIPAL"

   > O nome **`ScoreLabel`** precisa ser exato: o script o busca por
   > `$ScoreLabel`. Se renomear, ajuste o `@onready` no `.gd`.

3. Conecte `RetryButton` → `_on_retry_pressed` e `TitleButton` →
   `_on_title_pressed`.
4. `Scene → Save Scene As...` → `victory.tscn`, renomeie a raiz para
   **`Victory`**, troque o script para `victory.gd`, mude o texto para
   "VITÓRIA" e reconecte os sinais (`_on_play_again_pressed` e
   `_on_title_pressed`).

✅ **Teste:** F5 → JOGAR → Esc mostra derrota com a pontuação; Enter mostra
vitória. Os botões circulam entre as telas.

---

## 4. Limpeza

Quando a jogabilidade real existir, remova o `_unhandled_input` temporário de
`game.gd` e chame `end_in_defeat()` / `end_in_victory()` a partir das condições
verdadeiras (vidas esgotadas / última onda derrotada).

---

## Depois das telas: as entidades

A ordem que rende resultado visível mais rápido:

1. **`player.tscn`** — `CharacterBody2D` + `Sprite2D` (`sheriff.png`) +
   `CollisionShape2D`. Movimento com `move_left`/`move_right`.
2. **`bullet.tscn`** — `Area2D` + `Sprite2D` (`bullet.png`). Sobe e se destrói
   fora da tela. Dispare com `shoot`.
3. **`bandit.tscn`** — `Area2D` + `Sprite2D` (`bandit.png`). Morre ao ser
   atingido e avisa a fase para somar pontos.
4. **`barrel.tscn`** — `StaticBody2D` + `Sprite2D` (`barrel.png`), com vida
   que decrementa a cada acerto.

Salve todas em `scenes/entities/` com script correspondente em
`scripts/entities/`.
