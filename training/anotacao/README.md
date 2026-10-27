# Anotação do Dataset (Etapa 6)

Guia de anotação para os dois modelos. Ferramentas sugeridas: **Roboflow** (online, exporta YOLO) ou **Label Studio**/**CVAT** (local).

## modelo_arvore — Detecção (Modo Árvore)

Para cada foto da copa, anote no formato YOLO (um `.txt` por imagem, mesmo nome do `.jpg`):

- Um **box por fruto** com a classe de maturação:
  - `0` = fruto_verde
  - `1` = fruto_maduro
  - `2` = fruto_sobremaduro
- **Um box em toda a copa** com a classe de saúde:
  - `3` = arvore_saudavel
  - `4` = arvore_doente

Formato YOLO de cada linha: `classe x_centro y_centro largura altura` (normalizados 0–1).

### Estrutura de pastas
```
datasets/arvore/
├── images/
│   ├── train/
│   ├── val/
│   └── test/
└── labels/
    ├── train/
    ├── val/
    └── test/
```
Divisão sugerida: 70% train / 20% val / 10% test.

## modelo_doenca — Classificação (Modos Folha/Fruta)

Classificação binária: **sem boxes**, apenas organizar as imagens em pastas por classe. O Ultralytics treina com `yolov8n-cls.pt`.

### Estrutura de pastas
```
datasets/doenca/
├── train/
│   ├── saudavel/
│   └── greening/
├── val/
│   ├── saudavel/
│   └── greening/
└── test/
    ├── saudavel/
    └── greening/
```

> IMPORTANTE: só rotule como `greening` folhas/frutas com diagnóstico confirmado por agrônomo/análise laboratorial (ver `plano_amostragem.md`). Rótulos errados prejudicam muito o modelo.

## Ordem recomendada

1. Coletar imagens (Etapa 5) em `datasets/raw/`.
2. Anotar `arvore` (detecção) e organizar `doenca` (classificação).
3. Treinar: `train_arvore.py` e `train_doenca.py`.
4. Validar (Etapa 8) e exportar (Etapa 9): `export_litert.py` → `app/assets/models/`.
