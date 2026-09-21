# Assets

Recursos importados pela engine. Todo caminho aqui é referenciado como
`res://assets/...` dentro das cenas e scripts.

## Organização

```
assets/
└── sprites/
    ├── player/         # Xerife e seus projéteis
    ├── enemies/        # Bandidos, chefes e projéteis inimigos
    ├── environment/    # Cobertura destrutível, cenário
    └── ui/             # Telas, HUD, fontes de interface
```

## Convenções

- **Nomes em inglês**, `kebab-case`, sem acentos ou espaços — caminhos
  `res://` com espaços quebram em algumas plataformas de exportação.
- **Um conceito por arquivo.** Variações de estado usam sufixo descritivo
  (`boss.png`, `boss-low-health.png`), não numeração.
- **Pixel art é importada com filtro nearest.** O padrão está definido em
  `project.godot` (`default_texture_filter=0`); não altere por textura sem
  necessidade, ou as sprites ficarão borradas ao escalar.

## Adicionando um novo sprite

1. Crie o arquivo-fonte em [`art-source/`](../art-source/) na subpasta correspondente.
2. Exporte o PNG para a subpasta equivalente aqui em `assets/sprites/`.
3. Mantenha o mesmo nome base nos dois lados (`sheriff.aseprite` → `sheriff.png`).
4. Abra o Godot — a importação é automática e gera o `.png.import` correspondente.

> Os arquivos `.png.import` são gerados pela engine e **devem** ser versionados:
> eles carregam o UID estável que as cenas usam para referenciar a textura.
