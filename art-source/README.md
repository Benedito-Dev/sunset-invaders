# Art Source

Arquivos-fonte editáveis da arte do jogo. **A engine não lê esta pasta** — ela
existe para preservar o trabalho original, com camadas e frames intactos.

## Organização

Espelha a estrutura de [`assets/sprites/`](../assets/sprites/), com o mesmo nome
base em cada par de arquivos:

```
art-source/                      assets/sprites/
├── player/                      ├── player/
│   ├── sheriff.aseprite    →    │   ├── sheriff.png
│   └── bullet.aseprite     →    │   └── bullet.png
├── enemies/                     ├── enemies/
│   ├── bandit.aseprite     →    │   └── bandit.png
│   ├── boss.aseprite            │
│   └── boss-low-health.aseprite │
├── environment/                 ├── environment/
│   └── barrel.aseprite     →    │   └── barrel.png
└── ui/                          └── ui/
    └── title-screen.aseprite →      └── title-screen.png
```

## Ferramenta

Editado em [Aseprite](https://www.aseprite.org/). Ao exportar, use
`File → Export As` mantendo a escala em **1x** — o escalonamento é
responsabilidade da engine, não do arquivo.

## Fontes sem PNG exportado

Alguns `.aseprite` ainda não têm contraparte em `assets/` por serem de
conteúdo não implementado (`boss`, `boss-low-health`). Exporte-os quando a
mecânica correspondente entrar no jogo.
