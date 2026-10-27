# Arquitetura do Projeto — BPSEE (Etapa 2)

> Entregável da **Etapa 2 (Definição de Arquitetura)** do método SDD. Protótipo MVP, offline-first, mobile (Flutter, Android + iOS), inferência on-device.

---

## 1. Visão da Arquitetura (Protótipo)

O sistema é **100% client-side no protótipo**. Não há backend, servidor ou nuvem no fluxo de análise. Toda a inteligência fica embarcada no app.

```
┌─────────────────────────────────────────────────────┐
│                   APP FLUTTER (mobile)              │
│                                                     │
│  ┌───────────────┐      ┌────────────────────────┐  │
│  │  UI / UX      │      │  Camada de Análise CV  │  │
│  │               │      │                        │  │
│  │  • Seletor    │─────▶│  • Pré-processamento   │  │
│  │    Variedade  │      │  • Inferência on-device│  │
│  │  • Seletor    │      │  • Pós-processamento   │  │
│  │    Modo       │      │  • Gating por modo     │  │
│  │  • Câmera     │      └──────────┬─────────────┘  │
│  │  • Resultados │                 │                 │
│  │  • Histórico  │◀────────────────┘                 │
│  └───────────────┘                                  │
│                                                     │
│  ┌──────────────────┐   ┌────────────────────────┐  │
│  │  Modelos (assets)│   │  Persistência local    │  │
│  │                  │   │                        │  │
│  │  • modelo_arvore │   │  SQLite (sqflite)      │  │
│  │    .tflite       │   │  • Análises salvas     │  │
│  │  • modelo_doenca │   │  • Variedade + Modo    │  │
│  │    .tflite       │   │  • Imagem (opcional)   │  │
│  └──────────────────┘   └────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

> Não há chamadas de rede no protótipo. Tudo roda offline.

---

## 2. Decisão Central: 2 Modelos Separados

### Opções avaliadas

| Opção | Descrição | Prós | Contras |
|-------|-----------|------|---------|
| **A — 2 modelos (adotada)** | `modelo_arvore` (detecção de frutos + saúde) + `modelo_doenca` (greening em folha/fruta) | Especialização; menor por modelo; mais fácil de treinar e melhorar separadamente | 2 artefatos a manter |
| B — 1 modelo multitarefa | Um YOLO único para todas as classes | Mais simples no app | Classes muito diferentes (copa vs. folha); dataset híbrido difícil; confusão de escala/contexto |
| C — 1 modelo + gating por input | 1 modelo, ativado conforme modo | Simples | Mesmas limitações de B; escala e contexto visual totalmente distintos |

### Decisão: **Opção A — 2 modelos especializados**

**Justificativa:** Copa de árvore e folha individual são contextos visuais totalmente diferentes. O contexto de copa exige detecção de múltiplos objetos pequenos (frutos) em fundo de folhagem; o contexto de folha exige classificação/detecção de padrão de doença em detalhe. Treinar separado torna cada dataset menor, mais focado e mais fácil de anotar.

| Modelo | Arquivo | Classes | Entrada | Modo de uso |
|--------|---------|---------|---------|-------------|
| `modelo_arvore` | `modelo_arvore.tflite` | `fruto_verde`, `fruto_maduro`, `fruto_sobremaduro`, `arvore_saudavel`, `arvore_doente` | Foto da copa/árvore inteira | Modo Árvore |
| `modelo_doenca` | `modelo_doenca.tflite` | `saudavel`, `greening` | Foto de folha próxima ou fruta próxima | Modo Folha / Modo Fruta |

---

## 3. Fluxo de Dados Offline (por modo)

### Modo Árvore

```
Usuário seleciona variedade (seletor) + modo "Árvore"
        │
        ▼
Abre câmera → Tira foto da copa
        │
        ▼
Pré-processamento (resize, normalize)
        │
        ▼
modelo_arvore.tflite (on-device, YOLOv8 → TFLite)
        │
        ▼
Pós-processamento:
  • Contagem de frutos (fruto_verde + fruto_maduro + fruto_sobremaduro)
  • Estágio de maturação (% de cada classe)
  • Estimativa de frutos totais (contagem + fator de oclusão)
  • Estado geral (arvore_saudavel vs arvore_doente)
        │
        ▼
Resultados exibidos na UI + foto com bounding boxes
        │
        ▼
Opção: Salvar (SQLite) ou Descartar (padrão)
```

### Modo Folha / Modo Fruta

```
Usuário seleciona variedade (seletor) + modo "Folha" ou "Fruta"
        │
        ▼
Abre câmera → Tira foto da folha/fruta próxima
        │
        ▼
Pré-processamento (resize, normalize)
        │
        ▼
modelo_doenca.tflite (on-device, YOLOv8 → TFLite)
        │
        ▼
Pós-processamento:
  • Classificação: saudavel vs greening
  • Confiança da detecção
        │
        ▼
Resultados exibidos na UI + foto com bounding boxes / highlight
        │
        ▼
Opção: Salvar (SQLite) ou Descartar (padrão)
```

---

## 4. Diagrama de Componentes (Flutter)

```
lib/
├── main.dart
├── app/
│   ├── routes.dart               # Navegação
│   └── theme.dart                # Tema visual
├── features/
│   ├── selecao/                  # Seletor de variedade e modo
│   │   ├── selecao_page.dart
│   │   └── selecao_controller.dart
│   ├── captura/                  # Câmera + pré-visualização
│   │   ├── captura_page.dart
│   │   └── captura_controller.dart
│   ├── analise/                  # Inferência + pós-processamento
│   │   ├── analise_service.dart  # Gating + seleção do modelo
│   │   ├── arvore_analyzer.dart  # lógica modelo_arvore
│   │   └── doenca_analyzer.dart  # lógica modelo_doenca
│   ├── resultado/                # Exibição de resultados + opção salvar
│   │   ├── resultado_page.dart
│   │   └── resultado_controller.dart
│   └── historico/                # Listagem das análises salvas
│       ├── historico_page.dart
│       └── historico_controller.dart
├── data/
│   ├── models/                   # Entidades (AnaliseModel, etc.)
│   ├── repositories/             # Repositórios (SQLite)
│   └── database/                 # sqflite helper + migrations
└── core/
    ├── constants.dart            # Variedades, modos, labels
    └── utils/                    # Helpers de imagem, formatação
assets/
├── models/
│   ├── modelo_arvore.tflite
│   └── modelo_doenca.tflite
└── labels/
    ├── labels_arvore.txt
    └── labels_doenca.txt
```

---

## 5. Dependências Principais (Flutter)

| Pacote | Finalidade |
|--------|-----------|
| `camera` | Acesso à câmera do dispositivo |
| `tflite_flutter` | Execução on-device dos modelos TFLite |
| `image` | Pré-processamento de imagem (resize, normalize) |
| `sqflite` | Persistência local (SQLite) |
| `path_provider` | Caminhos de diretórios locais |
| `flutter_riverpod` | Gerenciamento de estado |

---

## 6. Pipeline de Treino (Python — fora do app)

```
Imagens brutas (campo)
        │
        ▼
Anotação YOLO (Roboflow ou Label Studio)
        │
        ▼
Treinamento YOLOv8 (Ultralytics Python)
  • modelo_arvore: classes de copa
  • modelo_doenca: classes de doença
        │
        ▼
Validação (mAP, precision, recall)
        │
        ▼
Export TFLite (ultralytics export format=tflite)
  + Quantização INT8 (tamanho + velocidade)
        │
        ▼
Teste de latência/tamanho no dispositivo-alvo
        │
        ▼
Cópia para assets/models/ do app Flutter
```

---

## 7. Arquitetura Futura (Etapa 20 — não bloqueia o protótipo)

```
┌────────────────┐        ┌───────────────────────┐
│   APP FLUTTER  │◀──────▶│  Backend FastAPI (AWS) │
│  (aut. + sync) │  HTTPS │  + PostgreSQL (RDS)   │
└────────────────┘        └───────────────────────┘
                                    │
                           ┌────────┴────────┐
                           │ Pipeline Retrain│
                           │ (AWS SageMaker) │
                           └─────────────────┘
```

Pontos de extensão já preparados no protótipo:
- `AnaliseRepository` com interface — SQLite no protótipo, PostgreSQL remoto no futuro.
- Entidades com campos `sincronizado` e `usuario_id` (nulos no protótipo).
- `AuthService` stub (sem lógica, pronto para implementar).

---

## 8. Critério de Aceite da Etapa 2

- [x] Decisão de 2 modelos justificada.
- [x] Fluxo de dados offline documentado (Modo Árvore + Modo Folha/Fruta).
- [x] Diagrama de componentes Flutter gerado.
- [x] Estrutura de pastas definida.
- [x] Dependências Flutter listadas.
- [x] Pipeline de treino Python documentado.
- [x] Pontos de extensão para evolução futura mapeados.
- [x] **Aprovação do usuário** — aprovado em 27/10/2026 (2 modelos separados e estrutura de pastas confirmados).

> ✅ Etapa 2 aprovada em 27/10/2026 e marcada como ✅ no `escopo.md`.
