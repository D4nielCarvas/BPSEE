# Requisitos do Projeto — BPSEE (Etapa 1)

> Entregável da **Etapa 1 (Levantamento de Requisitos)** do método SDD. Protótipo MVP, offline-first, mobile (Flutter, Android + iOS), inferência on-device.

---

## 1. Visão

Permitir que produtores, agrônomos e pesquisadores fotografem um pé de laranja (no campo, sem internet) e recebam, no próprio aparelho, análises de visão computacional conforme o alvo fotografado (árvore, folha ou fruta). A variedade é informada manualmente pelo usuário.

## 2. Requisitos Funcionais (RF)

| ID | Requisito | Detalhe |
|----|-----------|---------|
| RF-01 | App mobile multiplataforma | Flutter, Android e iOS. |
| RF-02 | Funcionamento 100% offline | A análise não depende de internet em nenhum momento. |
| RF-03 | Seleção de variedade (manual) | O usuário escolhe 1 de 7: Pêra, Valência Americana, Valência, Pêra Rio, Natal, Hamlin, Folha Murcha. |
| RF-04 | Seleção de modo de captura | O usuário escolhe: Árvore, Folha ou Fruta. |
| RF-05 | Captura por foto | Foto tirada pela câmera do aparelho (não tempo real), com pré-visualização. |
| RF-06 | Inferência on-device | Modelo embarcado (TFLite/ONNX) executa no aparelho, offline. |
| RF-07 | Análise — Modo Árvore | Retorna: contagem de frutos, estágio de maturação, estimativa de frutos, estado geral da planta. |
| RF-08 | Análise — Modo Folha | Retorna: detecção de doença (greening / HLB). |
| RF-09 | Análise — Modo Fruta | Retorna: detecção de doença (greening / HLB). |
| RF-10 | Apresentação visual dos resultados | Sobreposição dos resultados na foto (ex.: bounding boxes) + resumo legível. |
| RF-11 | Política de imagem — descartar por padrão | A foto é processada e descartada, sem armazenamento, salvo ação explícita do usuário. |
| RF-12 | Opção de salvar análise | Usuário pode salvar (imagem + resultados + variedade + modo) localmente. |
| RF-13 | Persistência local | Análises salvas ficam em SQLite local no aparelho. |
| RF-14 | Listagem de análises salvas | O usuário pode ver as análises salvas localmente. |
| RF-15 | Permissões de câmera e armazenamento | Solicitadas em tempo de execução, conforme a plataforma. |

## 3. Requisitos Não Funcionais (NFR)

| ID | Requisito | Meta / Critério verificável |
|----|-----------|------------------------------|
| NFR-01 | Desempenho de inferência | Latência da inferência ≤ 3 s em dispositivo intermediário (a confirmar na Etapa 9). |
| NFR-02 | Tamanho do modelo | Modelo embarcado ≤ 50 MB (a confirmar na Etapa 9). |
| NFR-03 | Usabilidade | Interface simples; fluxo de análise em poucos toques; texto em PT-BR. |
| NFR-04 | Acessibilidade | Contraste adequado, rótulos descritivos, cor não como único indicador (WCAG básico). |
| NFR-05 | Confiabilidade | Tratamento de erros de câmera e inferência com feedback claro ao usuário. |
| NFR-06 | Privacidade (protótipo) | Imagens descartadas por padrão; sem envio a servidores; sem login. |
| NFR-07 | Evolutibilidade | Estrutura preparada para futuro: AWS, PostgreSQL, login, LGPD, sync de histórico, retrain. |
| NFR-08 | Portabilidade | Build para Android (APK) e iOS (build para apresentação). |
| NFR-09 | Offline | Zero dependência de rede para qualquer fluxo do protótipo. |

## 4. Casos de Uso

**Ator:** Usuário (produtor, agrônomo ou pesquisador).

| ID | Caso de uso | Fluxo resumido |
|----|-------------|----------------|
| UC-01 | Selecionar variedade | Usuário abre o app e escolhe a variedade da planta que vai fotografar. |
| UC-02 | Selecionar modo de captura | Usuário escolhe Árvore, Folha ou Fruta. |
| UC-03 | Capturar foto | Usuário tira a foto do alvo, com pré-visualização. |
| UC-04 | Analisar (Modo Árvore) | App executa on-device e retorna contagem, maturação, estimativa e saúde. |
| UC-05 | Analisar (Modo Folha/Fruta) | App executa on-device e retorna detecção de greening. |
| UC-06 | Salvar análise | Usuário opta por salvar imagem + resultados + variedade + modo (SQLite local). |
| UC-07 | Descartar imagem | Usuário opta por descartar; nada é armazenado (padrão). |
| UC-08 | Visualizar análises salvas | Usuário consulta análises salvas localmente. |

## 5. Regras de Negócio

- RN-01: Nenhuma análise é executada sem seleção prévia de **variedade** e **modo**.
- RN-02: O modo de captura determina quais análises são executadas (gating); o modelo/fluxo varia conforme o modo.
- RN-03: A variedade é metadado da análise (não é inferida por CV) e pode, no futuro, calibrar a leitura de maturação.
- RN-04: Por padrão, a imagem é descartada após a análise; salvar é ação explícita do usuário.
- RN-05: Toda a análise ocorre offline; não há upload no protótipo.

## 6. Premissas e Restrições

- **Premissas:** dispositivo com câmera; usuário sabe identificar a variedade que está fotografando; fotos de folha/fruta próximas suficientes para o sintoma de greening.
- **Restrições (protótipo):** sem login; sem backend; sem nuvem; sem LGPD formal; dataset a ser construído; apenas greening como praga-alvo; sem tempo real; identificação automática de variedade fora de escopo.

## 7. Fora de Escopo (Protótipo)

- Identificação automática de variedade.
- Login de usuários.
- Backend, AWS e PostgreSQL.
- Histórico em nuvem / sincronização entre dispositivos.
- Conformidade formal com LGPD.
- Outras pragas/doenças além de greening.
- Captura em tempo real (vídeo/stream).
- Notificações e relatórios exportáveis.

## 8. Critério de Aceite da Etapa 1

- [x] RF e NFR listados e identificáveis (RF-01…RF-15, NFR-01…NFR-09).
- [x] Casos de uso mapeados (UC-01…UC-08).
- [x] Modos de captura e gating de análise definidos.
- [x] Variedade definida como input manual.
- [x] Fora de escopo explicitado.
- [x] **Aprovação do usuário** — aprovado em 27/10/2026 (metas de latência ≤ 3 s e modelo ≤ 50 MB confirmadas).

> ✅ Etapa 1 aprovada em 27/10/2026 e marcada como ✅ no `escopo.md`.
