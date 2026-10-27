# BPSEE

Sistema **mobile** (Flutter, Android + iOS) com **visão computacional** para analisar pés de laranja — **offline-first**, com inferência **on-device**. O usuário fotografa a árvore, a folha ou a fruta e o app traz as análises conforme o modo selecionado. A variedade é informada manualmente.

> Protótipo MVP em desenvolvimento pelo método **SDD (Speak Driven Design)**.

## Funcionamento (modos de captura)

| Modo | Alvo fotografado | Análises (CV) |
|------|------------------|---------------|
| Árvore | copa inteira | Contagem de frutos, maturação, estimativa, saúde geral |
| Folha | folha próxima | Detecção de greening (HLB) |
| Fruta | fruta próxima | Detecção de greening (HLB) |

## Estrutura

- `app/` — aplicativo Flutter (inferência on-device via TFLite/LiteRT)
- `training/` — pipeline Python (YOLOv8 → export on-device)
- Documentação SDD: `contexto.md`, `escopo.md`, `requisitos.md`, `arquitetura.md`, `stack.md`, `PADROES.md`

## Stack

- Mobile: Flutter 3.47.x + `tflite_flutter`
- Treino: Python 3.12 + Ultralytics (YOLOv8) via `uv`
- Persistência local: SQLite (sqflite)
- Futuro: AWS + PostgreSQL + login (estruturado, fora do protótipo)

## Pré-requisitos

- Flutter SDK (≥3.47) em `C:\src\flutter` (ou no PATH)
- Python 3.12 via `uv`
- Android Studio + Android SDK (necessário para rodar no Android)
- Git

## Quick start (app)

```powershell
cd app
flutter pub get
flutter run
```

## Documentação

- [Contexto](contexto.md) · [Escopo (20 etapas)](escopo.md) · [Requisitos](requisitos.md)
- [Arquitetura](arquitetura.md) · [Stack](stack.md) · [Padrões](PADROES.md)
