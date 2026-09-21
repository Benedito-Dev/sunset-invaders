# Scripts

Código do jogo (`.gd`). A estrutura espelha [`scenes/`](../scenes/): o script de
`scenes/screens/title.tscn` é `scripts/screens/title.gd`.

## Organização

```
scripts/
├── autoload/     # Singletons registrados em Project Settings → Autoload
│   └── scene_manager.gd
├── globals/      # Constantes e helpers sem estado, sem autoload
│   └── game_paths.gd
├── screens/      # Um por tela
├── entities/     # Um por entidade
└── components/   # Um por componente reutilizável
```

## SceneManager

Autoload já registrado. Cuida da troca de telas com fade e carrega a pontuação
entre a fase e as telas de fim de jogo.

```gdscript
SceneManager.goto_game()              # começa uma partida (zera o score)
SceneManager.goto_game_over(score)    # derrota, guardando a pontuação
SceneManager.goto_victory(score)      # vitória, guardando a pontuação
SceneManager.goto_title()             # volta ao título

SceneManager.last_score               # lido pelas telas de fim de jogo
```

Por que um autoload: sem ele, a tela de derrota precisaria conhecer o caminho da
fase, a fase precisaria conhecer o da derrota, e trocar qualquer arquivo de lugar
quebraria as duas. Com ele, cada cena conhece apenas o `SceneManager`.

## Convenções

- **`snake_case`** em arquivos, variáveis e funções; **`PascalCase`** em
  `class_name`; **`SCREAMING_SNAKE_CASE`** em constantes.
- **Métodos conectados a sinais começam com `_on_`** (`_on_play_pressed`), que é
  o padrão que o editor gera ao conectar pelo painel Node.
- **Privado começa com `_`** (`_fade_to`). GDScript não impõe isso, mas sinaliza
  ao leitor o que não deve ser chamado de fora.
- **Ordem dentro do arquivo:** `class_name` → `extends` → docstring `##` →
  sinais → constantes → `@export` → variáveis → `@onready` → `_ready` →
  métodos públicos → métodos privados.

## Input actions

Já registradas em `project.godot`:

| Ação | Teclas |
| :--- | :--- |
| `move_left` | ← / A |
| `move_right` | → / D |
| `shoot` | Espaço |
| `reload` | R |

Use sempre a ação, nunca a tecla direta:

```gdscript
if Input.is_action_pressed("move_left"):   # ✅ remapeável
if Input.is_key_pressed(KEY_A):            # ❌ preso ao teclado
```
