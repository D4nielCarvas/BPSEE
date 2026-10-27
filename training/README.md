# training/

Pipeline de **treino e export** dos modelos de visão computacional do BPSEE (lado Python).

Conteúdo previsto (Etapas 5–9):
- `datasets/` — imagens brutas e anotadas (gitignored)
- `notebooks/` — exploração e anotação
- `train_arvore.py` — treino do `modelo_arvore`
- `train_doenca.py` — treino do `modelo_doenca`
- `export_litert.py` — export para TFLite/LiteRT + quantização
- `runs/` — resultados de treino (gitignored)
- `weights/` — pesos `.pt` / `.onnx` (gitignored)

Os artefatos `.tflite` finais são copiados para `app/assets/models/` (versionados).

## Ambiente

```powershell
uv venv .venv --python 3.12
.venv\Scripts\activate
uv pip install "ultralytics[export-litert]"
```

## Lint

```powershell
uvx ruff check training/
uvx ruff format --check training/
```
