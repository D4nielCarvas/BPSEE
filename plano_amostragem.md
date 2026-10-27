# Plano de Amostragem — BPSEE (Etapa 5)

> Entregável documental da **Etapa 5 (Coleta de Imagens)** do método SDD. Define como coletar as imagens de campo para os dois modelos. As imagens são coletadas pelo usuário em campo; este plano orienta a coleta.

---

## 1. Objetivo

Construir o dataset inicial do protótipo para treinar:
- **`modelo_arvore`** (Modo Árvore): detecção de frutos + maturação + estado da árvore.
- **`modelo_doenca`** (Modo Folha e Modo Fruta): classificação saudável vs greening (HLB).

## 2. Premissas (confirmadas pelo usuário)

- Acesso a pomar com as **7 variedades**: Pêra, Valência Americana, Valência, Pêra Rio, Natal, Hamlin, Folha Murcha.
- **~30 imagens por variedade** como início do protótipo.
- Acesso a **plantas com greening confirmado**.

## 3. Orçamento de imagens (recomendado)

| Conjunto | Modelo | Quantidade | Balanceamento |
|----------|--------|-----------|---------------|
| Árvore (copa) | `modelo_arvore` | 30/var × 7 = **210** | Cobrir estágios de maturação (verde/maduro/sobremaduro) e árvores saudáveis + doentes |
| Folha (próxima) | `modelo_doenca` | **210** | ~105 saudável + ~105 greening |
| Fruta (próxima) | `modelo_doenca` | **210** | ~105 saudável + ~105 greening |
| **Total** | | **630** | |

> Para folha/fruta, o **balanceamento saudável vs greening** importa mais que a variedade (greening é semelhante entre variedades). Colete saudável entre as variedades e greening das plantas confirmadas (qualquer variedade).
>
> **Opção enxuta** (se 630 for muito): metade — 15/var árvore (105) + 100 folha + 100 fruta = ~305. A data augmentation do YOLOv8 ajuda a compensar.

## 4. Protocolo de captura por modo

### Modo Árvore (copa)
- Distância: 2–5 m, enquadramento da copa inteira (ou grande parte).
- Ângulos: frontal e lateral, de diferentes alturas (chão e mais alto).
- Cobertura: árvores com frutos em estágios variados (verde, maduro, sobremaduro); incluir saudáveis e, se houver, doentes.
- Iluminação: manhã, meio-dia, tarde; dias nublados e ensolarados.
- Evite fundos confusos (outras copas sobrepostas) quando possível.

### Modo Folha (próxima)
- Distância: 10–30 cm, folha focada e nítida.
- Folhas **saudáveis** e folhas com **sintoma de greening** (mancha clorótica assimétrica).
- Inclua folhas de diferentes partes da copa e alturas.
- Fundo neutro (cartão claro atrás) ajuda, mas não é obrigatório.

### Modo Fruta (próxima)
- Distância: 10–30 cm da fruta na planta.
- Frutas **saudáveis** e frutas com sinais de greening (fruta pequena/assimétrica/mal-formada, coloração irregular).
- Vários estágios de maturação.

## 5. Diversidade obrigatória

- Estágios de maturação (árvore/fruta): verde, maduro, sobremaduro.
- Horários: manhã, meio-dia, tarde.
- Condições: ensolarado e nublado.
- Ângulos: pelo menos 2 por árvore.
- Diferentes plantas por variedade (não repetir sempre a mesma árvore).

## 6. Greening (HLB) — o que registrar

- Sintoma-chave: **mancha clorótica assimétrica** na folha (diferente de deficiência nutricional, que é simétrica).
- **Confirmar o diagnóstico** com agrônomo/análise laboratorial antes de rotular como greening — rótulos errados prejudicam muito o modelo.
- Anote a variedade da planta de greening (se conhecida) — útil como metadado.

## 7. Qualidade mínima da foto

- Focada e nítida (sem tremor/desfoque).
- Resolução ≥ 1280 px no maior lado (smartphone atual basta).
- Sem dedos/objetos tampando o alvo.
- Evite sombras duras diretas sobre o alvo quando possível.

## 8. Estrutura de pastas (raw — gitignored)

```
training/datasets/raw/
├── arvore/
│   ├── pera/            # ~30 imgs
│   ├── valencia_americana/
│   ├── valencia/
│   ├── pera_rio/
│   ├── natal/
│   ├── hamlin/
│   └── folha_murcha/
├── folha/
│   ├── saudavel/        # ~105 imgs
│   └── greening/        # ~105 imgs
└── fruta/
    ├── saudavel/        # ~105 imgs
    └── greening/        # ~105 imgs
```

> As pastas já foram criadas localmente; basta depositar as fotos nelas.

## 9. Convenção de nomes

- Árvore: `{variedade}_{AAAAMMDD}_{NNN}.jpg` → ex.: `pera_20261103_001.jpg`
- Folha: `{saude}_{variedade-ou-nd}_{AAAAMMDD}_{NNN}.jpg` → ex.: `greening_pera_20261103_001.jpg`, `saudavel_nd_20261103_001.jpg`
- Fruta: mesma regra da folha.

Slugs de variedade: `pera`, `valencia_americana`, `valencia`, `pera_rio`, `natal`, `hamlin`, `folha_murcha`. Use `nd` se a variedade de uma folha/fruta de greening for desconhecida.

## 10. Checklist de coleta (fechamento da Etapa 5)

- [ ] ~30 imgs/árvore por variedade (210) em `raw/arvore/{variedade}/`.
- [ ] ~210 folhas balanceadas (saudável/greening) em `raw/folha/`.
- [ ] ~210 frutas balanceadas em `raw/fruta/`.
- [ ] Greening confirmado por agrônomo antes de rotular.
- [ ] Imagens nítidas, com nomes e pastas corretas.
- [x] **Plano de amostragem documentado** (este arquivo).

## 11. Próxima etapa

**Etapa 6 — Anotação do Dataset:** as imagens brutas serão anotadas no formato YOLO — caixas nos frutos (classes de maturação) e rótulos saudável/greening para folha/fruta. Ferramenta sugerida: Roboflow ou Label Studio.
