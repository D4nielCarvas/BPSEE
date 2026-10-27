# Contexto do Projeto — BPSEE

> Documento vivo, mantido segundo o método **SDD (Speak Driven Design)**: conversacional, em etapas, padronizado e verificável. Atualizado a cada decisão.

---

## 1. Visão Geral

O **BPSEE** é um sistema **mobile** que utiliza **visão computacional** para analisar um **pé de laranja** (*Citrus sinensis*) por meio da câmera do dispositivo e fornecer informações relevantes sobre a planta e seus frutos, funcionando **offline** (campo sem internet).

## 2. Objetivo

Permitir que produtores, agrônomos e pesquisadores apontem a câmera do celular para um pé de laranja e obtenham análises visuais que apoiem a tomada de decisão no manejo da cultura — com foco inicial em um **protótipo local** para testes e apresentação.

## 3. Arquitetura Decidida

- **100% mobile**, offline-first (uso em campo, sem internet).
- **Multiplataforma:** Android + iOS → **Flutter** (cross-platform).
- **Inferência on-device** (modelo embarcado no app) — sem depender de servidor na hora da análise.
- **Python** usado apenas no **treino/validação** do modelo (não há backend servindo inferência no protótipo).
- **Persistência local:** SQLite (protótipo).
- **Estruturado para futuro:** backend na AWS + PostgreSQL + login + sync de histórico + LGPD + pipeline de retrain.

## 4. Stack Tecnológica

| Camada | Protótipo (atual) | Futuro (estruturado) |
|--------|-------------------|----------------------|
| Mobile | Flutter (Android + iOS) | igual |
| Modelo CV | YOLOv8 → export on-device (TFLite/ONNX) | igual + pipeline de retrain |
| Treino do modelo | Python + Ultralytics | igual |
| Persistência | SQLite (local no app) | PostgreSQL (AWS) |
| Backend/API | — (não há no protótipo) | Python (FastAPI) na AWS |
| Cloud | — | AWS |
| Autenticação | — (uso sem login) | Login de usuários |

## 5. Saídas Desejadas do Modelo

> Decisão de escopo: a **identificação automática de variedade foi descartada**. A variedade é **informada manualmente pelo usuário** (seleção entre as 7). As análises são **gated por modo de captura** (árvore / folha / fruta).

**Entrada manual do usuário (não por CV):**
- Variedade: seleção entre Pêra, Valência Americana, Valência, Pêra Rio, Natal, Hamlin, Folha Murcha — vira metadado da análise; útil para futura calibração por variedade.

**Análises por modo de captura (foto tirada pelo usuário):**

| Modo | Alvo fotografado | Análises executadas (CV) |
|------|------------------|--------------------------|
| Árvore | copa/árvore inteira | Contagem de frutos, estágio de maturação, estimativa de frutos, estado geral da planta |
| Folha | folha próxima | Detecção de doença (greening / HLB) |
| Fruta | fruta próxima | Detecção de doença (greening / HLB) |

> ⚠️ **Dataset ainda não existe** — precisa ser coletado e anotado (Etapas 5 e 6 do escopo).

## 6. Segurança e Privacidade

- **Sem login** no protótipo.
- **Sem adesão à LGPD** no protótipo — porém o código/estrutura já são pensados para incorporá-la depois.
- Imagens **processadas e descartadas** por padrão.
- **Opção de salvar** a imagem/análise (local no protótipo).

## 7. Metodologia e Gestão

- **Scrum**.
- **Novo repositório Git** a ser criado.

## 8. Usuários Finais

- Produtores rurais, agrônomos e pesquisadores.
- **Histórico de análises:** futuro (protótipo sem histórico persistido em nuvem, mas estrutura preparada).

## 9. Decisões de Escopo (MVP)

- Protótipo primeiro: **local, offline, on-device**.
- **AWS/PostgreSQL = futuro**, não bloqueia o protótipo.
- **UI simples**, desenhada em conjunto.
- **Variedade = input manual** (não há identificação automática por CV).
- **Análises = gated por modo de captura** (árvore / folha / fruta).

## 10. Histórico de Decisões

| Data | Decisão | Justificativa |
|------|---------|---------------|
| 27/10/2026 | Mobile 100%, offline-first, Flutter | Uso em campo sem internet; multiplataforma |
| 27/10/2026 | Inferência on-device | Offline-first exige modelo no aparelho |
| 27/10/2026 | Python só para treino (sem backend no protótipo) | Protótipo não serve inferência |
| 27/10/2026 | Sem login / sem LGPD no protótipo | Foco em protótipo; estrutura preparada para futuro |
| 27/10/2026 | SQLite local (protótipo); PostgreSQL/AWS no futuro | Versão local para apresentação |
| 27/10/2026 | Sem dataset — coletar e anotar | Necessário construir dataset próprio |
| 27/10/2026 | Captura por foto (não tempo real) | Menor consumo de bateria; mais simples e preciso para análise múltipla |
| 27/10/2026 | Variedades-alvo: Pêra, Valência Americana, Valência, Pêra Rio, Natal, Hamlin, Folha Murcha | Definido pelo usuário; grafia Hamlin (padrão do cultivar) |
| 27/10/2026 | Praga-alvo inicial: greening (Huanglongbing / HLB) | Foco inicial; demais pragas como evolução |
| 27/10/2026 | Identificação de variedade DESCARTADA (aut.) | Usuário informa a variedade manualmente; elimina classificação difícil (clones da Pêra) |
| 27/10/2026 | Análises gated por modo de captura | Árvore → contagem/maturação/estimativa/saúde; Folha/Fruta → doença (greening) |
| 27/10/2026 | Stack definida: Flutter 3.47.8, tflite_flutter, Python 3.12 via uv | Etapa 3 aprovada |
| 27/10/2026 | Flutter via clone git em C:\src\flutter + PATH do usuário | Opção A; `flutter doctor` OK |
| 27/10/2026 | Repo/Scrum board = GitHub + GitHub Projects | Decisão do usuário |

## 11. Decisões da Etapa 1 (resolvidas)

- **Captura:** por **foto** tirada pelo usuário (não tempo real).
- **Variedades-alvo (7):** Pêra, Valência Americana, Valência, Pêra Rio, Natal, Hamlin, Folha Murcha.
  - Grafia: informado "hamline" → adotado **Hamlin** (cultivar padrão, origem Flórida).
- **Praga-alvo inicial:** **Greening** (Huanglongbing / HLB).
- **Variedade = input manual** (seletor no app), não saída de CV.
- **Modo de captura:** Árvore / Folha / Fruta — define quais análises são executadas.

## 12. Pontos a Validar Tecnicamente (Etapa 2)

- **Um modelo vs. dois modelos:** (a) modelo de árvore (detecção de frutos + maturação + saúde) e (b) modelo de folha/fruta (detecção de greening), ou um modelo multitarefa gated por modo.
- **Maturação por variedade:** Valência apresenta "regreening" (fruta madura ainda verde) — a variedade informada pode calibrar a leitura de maturação (oportunidade futura).
- **Greening por folha/fruta:** confirmar que fotos próximas de folha/fruta dão acurácia aceitável para o sintoma clorótico assimétrico.
- **Suficiência de dados:** dataset a construir do zero para as classes de detecção (fruto, greening, estágio de maturação, estado de saúde).
