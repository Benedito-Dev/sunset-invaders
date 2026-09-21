# Scenes

Cenas do jogo (`.tscn`). Os scripts vivem em [`scripts/`](../scripts/), na
subpasta de mesmo nome.

## Organização

```
scenes/
├── screens/      # Telas completas, trocadas pelo SceneManager
│   ├── title.tscn
│   ├── game.tscn
│   ├── game_over.tscn
│   └── victory.tscn
├── entities/     # Coisas que existem dentro da fase
│   ├── player.tscn
│   ├── bandit.tscn
│   ├── bullet.tscn
│   └── barrel.tscn
└── components/   # Peças reutilizáveis, plugáveis em qualquer entidade
    ├── health.tscn
    └── hitbox.tscn
```

### A diferença entre as três

- **`screens/`** — ocupa a tela inteira e é carregada por
  `get_tree().change_scene_to_file()`. Só existe uma por vez.
- **`entities/`** — instanciada dentro de uma screen, normalmente muitas ao
  mesmo tempo. O bandido, a bala, o barril.
- **`components/`** — não vive sozinha; é filha de uma entidade e resolve **uma**
  responsabilidade (vida, colisão, cadência de tiro). Quando duas entidades
  precisam do mesmo comportamento, ele vira componente em vez de ser copiado.

## Convenções

- **`snake_case`** nos nomes de arquivo (`game_over.tscn`), combinando com o
  script correspondente (`game_over.gd`).
- **`PascalCase`** nos nomes de nó dentro da cena (`ScoreLabel`, `SpawnPoint`).
- **O nó raiz tem o nome da cena**: `game_over.tscn` tem raiz `GameOver`.
- **Uma cena não conhece as outras telas.** Para trocar de tela, chame o
  `SceneManager`; nunca guarde um caminho `res://scenes/screens/...` solto
  dentro de uma entidade.

## Fluxo entre as telas

```
          ┌──────────┐
          │  title   │◄─────────────┐
          └────┬─────┘              │
               │ jogar              │ voltar ao título
               ▼                    │
          ┌──────────┐              │
    ┌─────┤   game   ├─────┐        │
    │     └──────────┘     │        │
    │ perdeu      venceu   │        │
    ▼                      ▼        │
┌───────────┐        ┌──────────┐   │
│ game_over ├────────┤ victory  ├───┘
└─────┬─────┘        └────┬─────┘
      │  jogar de novo    │
      └───────────────────┴──► game
```

Toda seta acima é uma chamada ao `SceneManager` — veja
[`scripts/README.md`](../scripts/README.md).
