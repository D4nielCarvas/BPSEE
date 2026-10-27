"""Treino do modelo_doenca (classificacao) do BPSEE - Modos Folha/Fruta.

Classes: saudavel, greening. Dataset em pastas por classe
(datasets/doenca/{train,val,test}/{saudavel,greening}).

Uso:
    uv run python train_doenca.py --epochs 50 --imgsz 224
"""
from __future__ import annotations

import argparse

from ultralytics import YOLO


def main() -> None:
    parser = argparse.ArgumentParser(description="Treino modelo_doenca (classificacao)")
    parser.add_argument("--model", default="yolov8n-cls.pt", help="pesos base (cls)")
    parser.add_argument("--data", default="datasets/doenca", help="raiz com train/ e val/")
    parser.add_argument("--epochs", type=int, default=50)
    parser.add_argument("--imgsz", type=int, default=224)
    parser.add_argument("--batch", type=int, default=32)
    args = parser.parse_args()

    model = YOLO(args.model)
    model.train(
        data=args.data,
        epochs=args.epochs,
        imgsz=args.imgsz,
        batch=args.batch,
        project="runs/doenca",
        name="train",
    )
    print("Treino do modelo_doenca concluido. Metricas em runs/doenca/train/")


if __name__ == "__main__":
    main()
