# Padrões de Projeto — BPSEE

> Documento de padrões da **Etapa 4 (Setup do Ambiente e Padrões)** do método SDD. Define estrutura, branches, commits, estilo de código e como rodar lint/format.

---

## 1. Estrutura do Repositório (monorepo)

```
BPSEE/
├── app/                    # App Flutter (Android + iOS) — inferência on-device
├── training/               # Pipeline Python (treino/export dos modelos)
├── contexto.md             # Contexto vivo do projeto (SDD)
├── escopo.md               # 20 etapas do escopo (SDD)
├── requisitos.md           # Requisitos (Etapa 1)
├── arquitetura.md          # Arquitetura (Etapa 2)
├── stack.md                # Stack e ferramental (Etapa 3)
├── PADROES.md              # Este arquivo
├── README.md               # Visão geral
└── pyproject.toml          # Tooling Python (ruff)
```

## 2. Branches (Git Flow lite)

- `main` — estável, sempre liberável para apresentação.
- `develop` — integração de features (opcional no protótipo).
- `feature/etapa-N-descricao` — uma feature/etapa por branch. Ex.: `feature/etapa-10-estrutura-base`.
- `fix/descricao` — correções.
- `docs/descricao` — apenas documentação.

Regra: nunca commitar direto em `main` (salvo bootstrap inicial).

## 3. Conventional Commits

Formato: `tipo(escopo): descrição`

Tipos:
- `feat:` nova funcionalidade
- `fix:` correção de bug
- `docs:` documentação
- `refactor:` refactor sem mudança de comportamento
- `test:` testes
- `build:` build/dependências
- `chore:` tarefas menores
- `ci:` pipeline

Ex.: `feat(analise): gating de modelo por modo de captura`
Ex.: `docs(escopo): marcar Etapa 3 como concluida`

## 4. Estilo de Código — Dart (app/)

- Linter: `flutter_lints` (já incluído no scaffold).
- Formater: `dart format` (padrão do Flutter).
- Regras extras: ver `app/analysis_options.yaml`.
- Cobertura mínima alvo: definida na Etapa 17.

```powershell
cd app
flutter analyze          # lint
dart format .            # formata
```

## 5. Estilo de Código — Python (training/)

- Linter/formater: `ruff` (config em `pyproject.toml`).
- Line length: 100. Target: Python 3.12.

```powershell
uvx ruff check training/
uvx ruff format training/
```

## 6. Padrões de Código

- Dart: nomes `lowerCamelCase` para variáveis/funções, `UpperCamelCase` para classes, `snake_case` para arquivos.
- Python: `snake_case` para variáveis/funções, `UpperCamelCase` para classes.
- Comentários e mensagens de commit/UI em **PT-BR**.
- Sem segredos no código (chaves/tokens via variáveis de ambiente).

## 7. Verificação Local (antes de commit)

```powershell
# Flutter
cd app; flutter analyze; dart format .
# Python
uvx ruff check training/; uvx ruff format --check training/
```

## 8. Evolução dos Padrões

Este documento é atualizado sempre que um novo padrão for definido (etapas seguintes: testes, CI/CD, deploy).
