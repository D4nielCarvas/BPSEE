# Stack e Ferramental — BPSEE (Etapa 3)

> Entregável da **Etapa 3 (Definição de Stack e Ferramental)** do método SDD. Matriz de tecnologia + estado do ferramental (verificado em 27/10/2026).

---

## 1. Visão

Definir e testar o ferramental do protótipo: lado mobile (Flutter + inferência on-device) e lado de treino (Python + Ultralytics), além do repositório e do Scrum board.

## 2. Ambiente Detectado (verificado em 27/10/2026)

| Ferramenta | Estado | Versão / Observação |
|-----------|--------|----------------------|
| Git | ✅ instalado | 2.53.0 |
| uv | ✅ instalado | 0.10.9 |
| Python (treino) | ✅ instalado via uv | 3.12.13 |
| Python (sistema) | ⚠️ presente mas fora do PATH | 3.14.3 em `AppData\Local\Python` (não usado) |
| Flutter SDK | ✅ instalado (clone) | 3.47.8 stable |
| Dart | ✅ instalado (com Flutter) | 3.13.x |
| Ultralytics + PyTorch | ⏸ diferido | instalação grande (~2 GB); feita na Etapa 5/7 |
| Android Studio + SDK | ⏸ pendente | necessário antes da Etapa 10/12 (rodar no Android) |

> Decisão: ambiente de treino usa **Python 3.12.13 via uv** (mais seguro com TensorFlow/PyTorch que o 3.14).

## 3. Matriz de Tecnologia — Mobile (Flutter)

| Pacote | Versão alvo | Finalidade |
|--------|-------------|-----------|
| Flutter SDK | 3.47.8 (stable) ✅ | framework mobile |
| Dart | 3.13.x (vem com Flutter) | linguagem |
| `tflite_flutter` | ^0.10.1 (LiteRT 1.4.0) | inferência on-device (TFLite/LiteRT) |
| `camera` | latest stable | acesso à câmera |
| `image` | latest stable | pré-processamento (resize/normalize) |
| `sqflite` | latest stable | persistência local (SQLite) |
| `path_provider` | latest stable | caminhos de diretórios |
| `flutter_riverpod` | latest stable | gerenciamento de estado |

> As versões "latest stable" serão pinadas exatamente no `pubspec.lock` na Etapa 4.

## 4. Matriz de Tecnologia — Treino (Python)

| Pacote | Versão alvo | Finalidade |
|--------|-------------|-----------|
| Python | 3.12.13 (via uv) ✅ | runtime |
| `ultralytics` | 8.4.x (pinar exacto na Etapa 5) | YOLOv8 treino + export |
| extra `export-litert` | junto com ultralytics | export TFLite/LiteRT on-device |
| `opencv` | via ultralytics | processamento de imagem |

## 5. Decisão: `tflite_flutter` (vs ONNX Runtime)

- **Adotado `tflite_flutter` (LiteRT):** export direto do Ultralytics (`format=tflite`/`litert`), pronto para Android e iOS (sem bibliotecas manuais nesses alvos).
- Pós-processamento NMS em Dart (implementado na Etapa 13/14).
- **Fallback:** ONNX Runtime, se LiteRT apresentar problema no iOS.

## 6. Licenciamento (atenção — marcado para Etapa 20)

- `ultralytics` = **AGPL-3.0**. OK para protótipo/testes/apresentação interna.
- Para **distribuição comercial**, exige licença Enterprise da Ultralytics ou modelo treinado sobre arquitetura não-AGPL. Decisão deferida para a evolução.

## 7. Ferramental de Projeto

| Item | Decisão | Status |
|------|---------|--------|
| Git | 2.53.0 | ✅ |
| Repositório remoto | GitHub | ✅ decidido (criação do remote na Etapa 4) |
| Scrum board | GitHub Projects | ✅ decidido |
| Ambiente Python | uv venv (`.venv`, gitignored) | na Etapa 4/5 |
| Flutter version mgmt | global (clone em `C:\src\flutter`) | ✅ executado |

## 8. Instalação do Flutter (concluída)

Opção **A — Clone git** executada em 27/10/2026:

```powershell
git clone -b stable https://github.com/flutter/flutter.git C:\src\flutter
# PATH do usuário atualizado com C:\src\flutter\bin (reversível)
```

Resultado: Flutter 3.47.8 stable, `flutter doctor` validado.

> Para usar `flutter` em terminal novo: abrir nova sessão (o PATH do usuário já está configurado).

## 9. Observações do `flutter doctor`

- ✅ Flutter 3.47.8 stable funcionando.
- ⚠️ "flutter binary is not on your path": cosmetic — o PATH do **usuário** já foi atualizado; nova sessão resolve.
- ❌ Android toolchain: Android SDK ausente → **instalar Android Studio antes da Etapa 10/12** (não bloqueia o scaffold agora).
- ❌ Visual Studio (desktop C++): **não necessário** (escopo é Android + iOS, não Windows desktop).
- ✅ Chrome, dispositivos conectados e rede OK.

## 10. Critério de Aceite da Etapa 3

- [x] Matriz de tecnologia definida com versões.
- [x] Ambiente detectado (git, uv, Python 3.12 via uv verificados).
- [x] Decisão `tflite_flutter` justificada.
- [x] Licenciamento AGPL sinalizado.
- [x] Flutter instalado (3.47.8) e `flutter doctor` validado.
- [x] Repositório/Scrum board definidos (GitHub + GitHub Projects).
- [x] **Aprovação do usuário** — aprovado em 27/10/2026.
- [ ] Android Studio + Android SDK — pendente (necessário antes da Etapa 10/12).

> ✅ Etapa 3 concluída em 27/10/2026 e marcada como ✅ no `escopo.md`.
