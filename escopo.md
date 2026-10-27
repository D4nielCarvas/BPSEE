# Escopo do Projeto — BPSEE

> Gerado pelo método **SDD (Speak Driven Design)**. Escopo refinado após definição de arquitetura: **mobile 100%, offline-first, inferência on-device**. Backend AWS/PostgreSQL = **futuro** (estruturado, não bloqueia o protótipo). Cada etapa tem **critério de conclusão verificável**.

---

## Objetivo do Escopo

Quebrar o desenvolvimento do protótipo do BPSEE (app Flutter offline com visão computacional para análise de pés de laranja) em **20 etapas/subetapas**, padronizadas e verificáveis, executadas de forma gradual e fluida. Nenhuma etapa avança sem que a anterior esteja concluída e verificada.

## Princípios do SDD aplicados

- Desenvolvimento **conversacional**, em etapas.
- Cada etapa possui **critério de conclusão verificável**.
- Documentação (`contexto.md` / `escopo.md` / `requisitos.md`) atualizada a cada etapa.
- **Revisão** antes de avançar para a próxima etapa.
- Execução **padronizada** (mesmos padrões de código, teste, commit e build ao longo do projeto).

## Legenda de Status

- ⬜ A iniciar — 🟡 Em andamento — ✅ Concluída e verificada

## Nota de Escopo (MVP vs Futuro)

- **MVP (etapas 1–19):** Flutter + modelo on-device + SQLite local + offline, sem login.
- **Futuro (etapa 20 — estruturação):** AWS + PostgreSQL + login + sync de histórico + LGPD + retrain pipeline.
- **Variedade** = input manual do usuário (não há identificação automática por CV).
- **Análises** = gated por modo de captura (árvore / folha / fruta).

---

## As 20 Etapas

| # | Etapa | Descrição | Critério de Conclusão (verificável) | Status |
|---|------|-----------|--------------------------------------|--------|
| 1 | Levantamento de Requisitos | RF/NFR, casos de uso, captura por foto, variedade como input manual, modo de captura, praga-alvo (greening). | Documento de requisitos (`requisitos.md`) aprovado; casos de uso mapeados. | ✅ |
| 2 | Definição de Arquitetura | Confirmar on-device, Flutter, SQLite local, export TFLite/ONNX; decidir 1 vs 2 modelos (árvore vs folha/fruta); diagrama de componentes e fluxo de dados offline. | Diagrama de arquitetura + fluxo de dados + justificativas documentadas. | ✅ |
| 3 | Definição de Stack e Ferramental | Flutter, Python/Ultralytics, tflite_flutter ou onnxruntime, Git, Scrum board (issues por etapa). | Matriz de tecnologia aprovada; ferramental instalado e testado. | ✅ |
| 4 | Setup do Ambiente e Padrões | Repo Git criado, estrutura de pastas, lint/format (Dart + Python), convenções de commit, README de padrões. | Repo inicializado; lint/format rodando; README de padrões publicado. | ✅ |
| 5 | Coleta de Imagens | Coletar fotos por modo (árvore: copa; folha e fruta: próximas), várias variedades/estágios/pragas/ângulos/iluminação. | Conjunto bruto de imagens versionado; plano de amostragem documentado. | 🟡 |
| 6 | Anotação do Dataset | Definir classes de detecção (fruto, greening/doença, estágio de maturação, estado de saúde) e anotar em YOLO — variedade NÃO é classe (input manual). | Dataset anotado e dividido (train/val/test) no formato YOLO, com subconjuntos por modo (árvore / folha-fruta). | ⬜ |
| 7 | Treinamento do Modelo (YOLOv8) | Treinar e ajustar hiperparâmetros em Python (1 ou 2 modelos conforme Etapa 2). | Modelo treinado com mAP/precision/recall registrados; pesos versionados. | ⬜ |
| 8 | Validação do Modelo | Avaliar em conjunto de teste e edge cases. | Relatório de validação com métricas e exemplos de falha. | ⬜ |
| 9 | Otimização/Exportação On-device | Exportar (TFLite/ONNX), quantizar e medir latência/tamanho no dispositivo-alvo. | Artefato otimizado gerado; latência e tamanho medidos e aceitáveis. | ⬜ |
| 10 | Flutter — Estrutura Base | Scaffold do app, navegação, temas, configs, ambiente local (emulador/dispositivo). | App compila e roda com navegação básica em Android e iOS. | ⬜ |
| 11 | Flutter — UI/UX e Telas | Wireframe conjunto (simples); telas de captura com seletor de **variedade** (7) e **modo** (árvore/folha/fruta), resultados, configurações. | Telas implementadas conforme wireframe; acessibilidade básica; seletores funcionais. | ⬜ |
| 12 | Flutter — Integração com Câmera | Permissões, captura de foto por modo e pré-visualização. | Câmera funcional com permissões e fluxo de captura por modo testado offline. | ⬜ |
| 13 | Flutter — Execução On-device do Modelo | Carregar modelo TFLite/ONNX e rodar inferência no app (offline), conforme modo. | Inferência retornando resultados no dispositivo; latência medida. | ⬜ |
| 14 | Flutter — Pós-processamento e Resultados | Traduzir saídas do modelo em UI conforme modo: árvore → contagem/maturação/estimativa/saúde; folha/fruta → doença (greening); variedade vem do seletor. | Resultados apresentados na UI conforme o modo de captura selecionado. | ⬜ |
| 15 | Persistência Local e Opção de Salvar | SQLite local; política processar-e-descartar com opção de salvar imagem/análise. | Imagem descartada por padrão; salvar opcional funcionando; estrutura para histórico. | ⬜ |
| 16 | Tratamento de Erros e Acessibilidade | Offline garantido, erros de inferência/câmera, feedback ao usuário, acessibilidade. | Cenários de erro testados; fluxo offline 100% funcional. | ⬜ |
| 17 | Testes (Unit / Integração / E2E) | Testes do app e avaliação do modelo com imagens reais em campo. | Suíte de testes verde; relatório de acurácia em campo. | ⬜ |
| 18 | CI/CD e Build Local | Automatizar build/testes e gerar APK + build iOS para apresentação. | Pipeline local verde; APK e build iOS gerados. | ⬜ |
| 19 | Empacotamento e Apresentação do Protótipo | Demo instalável + roteiro de apresentação + documentação. | App instalável; roteiro de demo pronto; protótipo apresentável. | ⬜ |
| 20 | Estruturação para Evolução | Hooks arquiteturais para AWS + PostgreSQL + login + LGPD + sync de histórico + retrain. | Documento de evolução com pontos de extensão mapeados no código. | ⬜ |

---

## Notas

- A Etapa 1 resolveu as perguntas em aberto: captura por **foto**; variedades-alvo (7); praga-alvo (**greening**); variedade como **input manual**; análise **gated por modo** de captura.
- Cada etapa gerará um **checkpoint verificável** (artefato, teste ou métrica) registrado neste documento.
- Decisões relevantes serão registradas em `contexto.md` (seção 10).
- **Pendências do usuário:** (1) criar o remote no GitHub (gh não instalado — criar em github.com e passar a URL, ou instalar `gh` + `gh auth login`); (2) instalar Android Studio + Android SDK antes da Etapa 10/12 (rodar no Android).
