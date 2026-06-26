# Registro de Decisões — Trabalho de Séries Temporais

Arquivo para registrar decisões tomadas ao longo do projeto, com justificativas e alternativas consideradas.

---

## D001 — Escolha do Recorte Espacial

**Status:** ✅ DEFINIDO

**Decisão:** **Belo Horizonte (MG)** — aba `WATER_CITY_MENSAL`

**Justificativa:** Cidade de grande relevância ambiental e hídrica em Minas Gerais, com 40 anos de dados mensais completos (1985–2024), totalizando 480 observações — série suficientemente longa para modelagem robusta.

**Ação:** Registrar no fórum da disciplina para reservar este município.

**Dados confirmados:**
- Colunas: `code`, `municipality`, `state`, `year`, `january` … `december`
- Linhas para BH: 40 (uma por ano)
- Anos disponíveis: 1985–2024

---

## D002 — Problema no Notebook Atual

**Status:** ✅ Identificado — precisa ser corrigido

**Problema:** O notebook `series_temporais.ipynb` atual usa:
- Aba `WATER_CITY_MENSAL` (municipal, mensal)
- Município: Belo Horizonte
- Divisão treino/teste em torno do "desastre de Brumadinho" (Jan/2019)

**O que foi corrigido:**
1. O município **Belo Horizonte** foi confirmado como a unidade de análise (D001 ✅)
2. O ponto de corte treino/teste (Jan/2019) foi ajustado para Jan/2020 — critério neutro (D003 ✅)
3. A estrutura do notebook (mensal, municipal) está **correta** ✅

**Status atual:** Notebook reescrito com todos os modelos e critérios corretos.

---

## D003 — Ponto de Corte Treino/Teste

**Status:** ✅ DEFINIDO

**Decisão:**
- Treino: jan/1985 – dez/2019 → `window(ts_bh, end = c(2019, 12))` → **420 meses**
- Teste: jan/2020 – dez/2024 → `window(ts_bh, start = c(2020, 1))` → **60 meses**
- Horizonte: `h = length(ts_teste)` = **60**

**Justificativa:** Últimos 5 anos (≈ 12,5% da série) reservados como teste, garantindo base de treino suficientemente longa (35 anos) para ajuste sazonal. Corte em 2019/2020 é neutro — sem viés de eventos externos.

---

## D004 — Modelos a Aplicar

**Status:** ✅ Definido pela professora

**Modelos obrigatórios** (conforme transcrição da aula):
| Modelo | Função R | Pacote |
|--------|----------|--------|
| Suavização Exponencial Simples (SES) | `ses()` | `forecast` |
| Holt (Tendência) | `holt()` | `forecast` |
| Holt-Winters (Tendência + Sazonalidade) | `hw()` | `forecast` |
| ARIMA / SARIMA | `auto.arima()` | `forecast` |
| Espaço de Estados (ETS) | `ets()` | `forecast` |

**Nota:** VAR (multivariado) **não é necessário** — confirmado pela professora na aula.

**Observação:** Com série **mensal** (`frequency = 12`), o Holt-Winters é plenamente aplicável — existe componente sazonal anual (12 meses) a ser modelado. O `auto.arima` poderá identificar também modelos **SARIMA** capturando a sazonalidade.

---

## D005 — Critérios de Avaliação e Comparação

**Status:** ✅ Definido pela professora

**Critérios:**
1. **AIC** — critério de informação para comparação na etapa de modelagem (em `summary()`)
2. **RMSE** — raiz do erro quadrático médio na base de teste via `accuracy(modelo, ts_teste)`

**Questão de pesquisa do trabalho:** O modelo com menor AIC também apresenta menor RMSE na previsão?

---

## D006 — Frequência da Série Temporal

**Status:** ✅ Revisado

**Decisão:** Usar dados **mensais** (`frequency = 12`).

**Justificativa:** Embora o enunciado mencione "anuais", a professora confirmou que o arquivo Excel possui tanto dados anuais quanto mensais, e os dados mensais são mais ricos para a construção de modelos de séries temporais — permitem capturar sazonalidade e produzem mais observações para o ajuste. A escolha pelos dados mensais é metodologicamente superior.

**Impacto no código:**
```r
# Série mensal, a partir de janeiro de 1985
ts_dados <- ts(vetor_area, start = c(1985, 1), frequency = 12)

# Divisão treino/teste com índice mensal
ts_treino <- window(ts_dados, end = c(2018, 12))
ts_teste  <- window(ts_dados, start = c(2019, 1))
horizonte <- length(ts_teste)
```

---

## D007 — Pacotes R Necessários

**Status:** ✅ Definido

| Pacote | Uso |
|--------|-----|
| `readxl` | Leitura do arquivo Excel |
| `dplyr` | Manipulação de dados |
| `forecast` | Todos os modelos de ST e `accuracy()` |
| `tseries` | Teste ADF de estacionariedade |
| `ggplot2` | Gráficos (opcional, complementar) |

**Não necessário:** `vars` (apenas para VAR)

---

## D008 — Estrutura do Artigo

**Status:** ✅ DEFINIDO

**Formato escolhido:** **Resumo expandido (6–9 páginas)**

**Modelo de referência:** `docs/MODELO-ARTIGO-CIENTIFICO (1) (1).docx`

**Normas:** ABNT NBR 6023:2018 (citações e referências)

**Seções obrigatórias:**
- Título, Autores
- Resumo (100–250 palavras) + Abstract
- Palavras-chave (3–5)
- 1. Introdução (contexto + revisão de 2–3 artigos + objetivo)
- 2. Desenvolvimento / Metodologia e Resultados (dados + modelos + resultados + discussão)
- 3. Considerações Finais
- Referências

**Entregáveis:** `.pdf` e `.docx`

---

## Log de Alterações

| Data | Decisão | Descrição |
|------|---------|-----------|
| 2026-05-28 | D001–D008 | Criação inicial do registro de decisões |
| 2026-05-28 | D001, D006 | Correção: escopo é Cidade ou Bioma (não Estado); frequência é mensal (não anual) |
| 2026-05-28 | D001 | **Belo Horizonte (MG)** escolhida como cidade de análise |
| 2026-05-28 | D003 | Corte treino/teste definido: treino 1985–2019, teste 2020–2024 |
| 2026-05-28 | D008 | Formato do artigo definido: resumo expandido (6–9 páginas) |
