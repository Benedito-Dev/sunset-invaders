<div align="center">

# 🌅 Sunset Invaders

**Space Invaders com as botas sujas de poeira do Velho Oeste.**

[![Godot](https://img.shields.io/badge/Godot-4.7-478CBF?style=flat-square&logo=godotengine&logoColor=white)](https://godotengine.org/)
[![Status](https://img.shields.io/badge/status-em%20desenvolvimento-orange?style=flat-square)](#-status)
[![License](https://img.shields.io/badge/licen%C3%A7a-MIT-green?style=flat-square)](LICENSE)

</div>

---

## 🤠 Sobre

O sol se põe sobre a cidade e, no horizonte, fileiras de fora-da-lei avançam em
formação. Você é a última arma entre eles e a cidade: atrás de barris que se
despedaçam a cada tiro, com o dedo no gatilho e o cartucho contado.

**Sunset Invaders** é uma releitura do clássico arcade de 1978 que troca as naves
alienígenas por bandidos a cavalo, o canhão laser por um revólver e o vácuo do
espaço por um crepúsculo alaranjado no deserto.

Sem naves. Sem laser. Só você, o revólver e o pôr do sol.

## 🎯 Conceito

| Space Invaders (1978) | Sunset Invaders |
| :--- | :--- |
| Naves alienígenas | Fora-da-lei a cavalo |
| Canhão laser | Revólver de seis tiros |
| Espaço sideral | Deserto ao entardecer |
| Bunkers de defesa | Barris e carroças |
| Munição infinita | Cartucho contado, recarga manual |

## ✨ Pilares de design

- **🔫 Saque rápido** — seis tiros no tambor. A recarga é o seu momento de maior
  vulnerabilidade, e o inimigo sabe disso.
- **🎺 Tensão crescente** — a formação acelera conforme os bandidos caem, no
  mesmo crescendo que tornou o original inesquecível.
- **🛢️ Cobertura destrutível** — barris e carroças absorvem chumbo até virarem
  lascas. O terreno muda a cada partida.
- **🌇 Pôr do sol como cronômetro** — a luz cai enquanto a onda avança. Quando a
  noite chegar, você já terá decidido seu destino.

## 🛠️ Tecnologias

| Componente | Escolha |
| :--- | :--- |
| Engine | [Godot 4.7](https://godotengine.org/) |
| Renderizador | Forward Plus |
| Física | Jolt Physics |
| Driver gráfico | Direct3D 12 (Windows) |
| Linguagem | GDScript |

## 🚀 Como executar

### Pré-requisitos

- [Godot Engine 4.7](https://godotengine.org/download) ou superior

### Passos

```bash
# Clone o repositório
git clone https://github.com/Benedito-Dev/sunset-invaders.git

# Entre na pasta
cd sunset-invaders
```

Em seguida, abra o **Godot Engine**, clique em `Importar`, selecione o arquivo
`project.godot` na pasta clonada e pressione `F5` para rodar.

## 📁 Estrutura do projeto

```
sunset-invaders/
├── scenes/             # Cenas .tscn
│   ├── screens/            # Telas: título, fase, derrota, vitória
│   ├── entities/           # Jogador, bandidos, projéteis, cobertura
│   └── components/         # Peças reutilizáveis (vida, hitbox)
├── scripts/            # Código .gd, espelhando scenes/
│   ├── autoload/           # Singletons (SceneManager)
│   ├── globals/            # Constantes e helpers
│   ├── screens/
│   ├── entities/
│   └── components/
├── assets/             # Recursos importados pela engine
│   ├── sprites/            # player, enemies, environment, ui
│   ├── audio/              # music, sfx
│   └── fonts/
├── resources/          # .tres customizados (ondas, configs de inimigo)
├── art-source/         # Arquivos .aseprite (ignorados pela engine)
├── icon.svg
├── LICENSE
└── project.godot
```

Cada pasta tem README próprio com suas convenções: [`scenes/`](scenes/README.md),
[`scripts/`](scripts/README.md), [`assets/`](assets/README.md) e
[`art-source/`](art-source/README.md).

**Começando pelas cenas?** O passo a passo para criar as quatro telas está em
[`scenes/screens/COMO_CRIAR.md`](scenes/screens/COMO_CRIAR.md).

## 🗺️ Roadmap

- [x] Estrutura de pastas e navegação entre telas (SceneManager)
- [ ] Cenas das quatro telas
- [ ] Movimentação e disparo do jogador
- [ ] Formação de inimigos com aceleração progressiva
- [ ] Sistema de munição e recarga
- [ ] Cobertura destrutível (barris e carroças)
- [ ] Ciclo de iluminação do pôr do sol
- [ ] Sistema de pontuação e recordes
- [ ] Trilha sonora e efeitos sonoros
- [ ] Menu principal e telas de transição

## 🚧 Status

Projeto em desenvolvimento ativo, nas fases iniciais. O esqueleto da engine está
configurado e a implementação das mecânicas está em andamento.

## 🤝 Contribuindo

Sugestões, issues e pull requests são bem-vindos. Para mudanças significativas,
abra uma issue antes para discutirmos a proposta.

## 📄 Licença

Distribuído sob a licença MIT. Veja [`LICENSE`](LICENSE) para mais detalhes.

---

<div align="center">

Feito com 🤠 e ☕ por [**Benedito Bittencourt**](https://github.com/Benedito-Dev)

</div>
