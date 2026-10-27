"""Exporta os modelos treinados para TFLite/LiteRT (on-device) e copia para o app.

Quantizacao INT8 para reduzir tamanho/latencia (meta: <=50 MB e <=3 s).

Uso:
    uv run python export_litert.py \
        --arvore runs/arvore/train/weights/best.pt \
        --doenca runs/doenca/train/weights/best.pt
"""
from __future__ import annotations

import argparse
import shutil
from pathlib import Path

from ultralytics import YOLO

APP_MODELS = Path("../app/assets/models")


def export_one(weights: str) -> Path:
    model = YOLO(weights)
    out = model.export(format="tflite", int8=True)
    return Path(out)


def main() -> None:
    parser = argparse.ArgumentParser(description="Export on-device (LiteRT/TFLite)")
    parser.add_argument("--arvore", help="best.pt do modelo_arvore")
    parser.add_argument("--doenca", help="best.pt do modelo_doenca")
    args = parser.parse_args()

    APP_MODELS.mkdir(parents=True, exist_ok=True)

    if args.arvore:
        p = export_one(args.arvore)
        shutil.copy(p, APP_MODELS / "modelo_arvore.tflite")
        print(f"modelo_arvore -> {APP_MODELS / 'modelo_arvore.tflite'}")

    if args.doenca:
        p = export_one(args.doenca)
        shutil.copy(p, APP_MODELS / "modelo_doenca.tflite")
        print(f"modelo_doenca -> {APP_MODELS / 'modelo_doenca.tflite'}")


if __name__ == "__main__":
    main()
