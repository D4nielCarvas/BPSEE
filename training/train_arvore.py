"""Treino do modelo_arvore (deteccao) do BPSEE - Modo Arvore.

Classes (ver data_arvore.yaml): fruto_verde, fruto_maduro,
fruto_sobremaduro, arvore_saudavel, arvore_doente.

Uso:
    uv run python train_arvore.py --epochs 100 --imgsz 640
"""
from __future__ import annotations

import argparse

from ultralytics import YOLO


def main() -> None:
    parser = argparse.ArgumentParser(description="Treino modelo_arvore (deteccao)")
    parser.add_argument("--model", default="yolov8n.pt", help="pesos base")
    parser.add_argument("--data", default="data_arvore.yaml", help="arquivo data.yaml")
    parser.add_argument("--epochs", type=int, default=100)
    parser.add_argument("--imgsz", type=int, default=640)
    parser.add_argument("--batch", type=int, default=16)
    args = parser.parse_args()

    model = YOLO(args.model)
    model.train(
        data=args.data,
        epochs=args.epochs,
        imgsz=args.imgsz,
        batch=args.batch,
        project="runs/arvore",
        name="train",
    )
    print("Treino do modelo_arvore concluido. Metricas em runs/arvore/train/")


if __name__ == "__main__":
    main()
