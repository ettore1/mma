---
applyTo: "**"
---

# Instruções do Projeto — Séries Temporais (CEMMA)

## Visão Geral

Trabalho avaliativo da disciplina **Séries Temporais** da Especialização em Métodos Matemáticos Aplicados (CEMMA), Profa. Sheila Regina Oro.

**Objetivo:** Modelar e prever áreas de superfície de água (ha) de uma **Cidade (município)** ou de um **Bioma** brasileiro, utilizando dados **mensais** do **Projeto MapBiomas Água, Coleção 4**.

**Entregável:** Artigo científico (10–20 p) ou resumo expandido (6–9 p) + código reproduzível em R.

---

## Dataset

- **Arquivo:** `STATISTICS_MAPBIOMAS_AGUA_COL4_CITY-STATE-BIOME-SUB_BASINS_DOI.xlsx`
- **Fonte:** Projeto MapBiomas Água (citar nas referências do artigo)
- **Abas relevantes:** `WATER_CITY_MENSAL` (municípios mensais) e abas de Bioma — usar dados **mensais**
- **Recorte espacial:** Cidade ou Bioma a ser definido (ver `DECISOES.md` D001)
- **Variável:** área de superfície de água em hectares (ha)
- **Período esperado:** 1985–2023 (aprox.) — ≈ 468 observações mensais

---

## Ambiente de Desenvolvimento

- **Linguagem:** R 4.6.0 (`C:\Program Files\R\R-4.6.0\bin\R.exe`)
- **Ambiente:** Jupyter Notebook com kernel R (IRkernel 1.3.2)
- **Notebook principal:** `series_temporais.ipynb`
- **Pacotes necessários:** `readxl`, `dplyr`, `forecast`, `tseries`, `ggplot2`
- **Biblioteca do usuário R:** `%USERPROFILE%\AppData\Local\R\win-library\4.6`

---

## Modelos Obrigatórios (definido pela professora)

| ID | Modelo | Função R |
|----|--------|----------|
| SES | Suavização Exponencial Simples | `ses(ts_treino, h=horizonte)` |
| SEH | Holt (Tendência) | `holt(ts_treino, h=horizonte)` |
| HW | Holt-Winters | `hw(ts_treino, h=horizonte)` |
| ARIMA | Box-Jenkins (automático) | `auto.arima(ts_treino)` |
| ETS | Espaço de Estados | `ets(ts_treino)` |

**VAR não é necessário** — série univariada.

---

## Critérios de Avaliação

- **AIC** — critério de seleção de modelos (etapa de modelagem)
- **RMSE** — erro preditivo na base de teste via `accuracy(modelo, ts_teste)`
- **Questão de pesquisa:** o melhor modelo por AIC também é o melhor em RMSE?

---

## Estrutura de Pastas

```
series_temporais/
├── series_temporais.ipynb     # Notebook principal (R)
├── STATISTICS_MAPBIOMAS_...xlsx  # Dados originais
├── PLANO.md                   # Plano de implementação com checklist
├── DECISOES.md                # Registro de decisões e justificativas
├── .github/
│   └── copilot-instructions.md  # Este arquivo
└── docs/
    ├── Parte1-EMMA08.R        # Script aula — análise exploratória
    ├── Parte2-EMMA08.R        # Script aula — modelos de suavização e ARIMA
    ├── Parte3-EMMA08.R        # Script aula — ETS e VAR
    ├── Parte4-EMMA08.R        # Script aula — comparação e previsão
    ├── recomendacoes.txt      # Instruções da atividade
    └── transcricao_aula.txt   # Transcrição da aula sobre a avaliação
```

---

## Convenções de Código R

```r
# Série temporal mensal
ts_dados <- ts(vetor_area, start = c(1985, 1), frequency = 12)

# Divisão treino/teste (ajustar conforme D003 em DECISOES.md)
ts_treino <- window(ts_dados, end = c(2018, 12))
ts_teste  <- window(ts_dados, start = c(2019, 1))
horizonte <- length(ts_teste)  # número de meses no período de teste

# Diagnóstico padrão para cada modelo
summary(modelo)                         # AIC e coeficientes
cpgram(modelo$residuals)               # Periodograma dos resíduos
checkresiduals(modelo)                 # Teste Ljung-Box + gráficos
accuracy(forecast(modelo, h=horizonte), ts_teste)  # RMSE no teste
```

---

## Estado Atual do Notebook

> **⚠️ O notebook precisa ser atualizado:**
> - Usa **Belo Horizonte** como exemplo (município placeholder)
> - O recorte espacial deve ser substituído pela Cidade ou Bioma escolhido (D001)
> - O ponto de corte treino/teste referencia o "desastre de Brumadinho" — substituir por critério neutro (D003)
> - A estrutura geral (mensal, municipal) está **correta**

**Primeira ação:** explorar as abas do Excel, escolher a Cidade/Bioma e atualizar o notebook conforme `PLANO.md`.

---

## Fluxo de Trabalho

1. Consultar `DECISOES.md` para ver decisões pendentes e tomadas
2. Consultar `PLANO.md` para ver as tarefas com checklist
3. Toda nova decisão relevante deve ser registrada em `DECISOES.md`
4. Ao completar uma etapa do plano, marcar o checkbox em `PLANO.md`
