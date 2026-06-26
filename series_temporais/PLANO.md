# Plano de Implementação — Trabalho de Séries Temporais

## Contexto

Trabalho avaliativo da disciplina **Séries Temporais** (Especialização em Métodos Matemáticos Aplicados — CEMMA). A professora solicita um artigo científico (10–20 páginas) ou resumo expandido (6–9 páginas) sobre a modelagem e previsão de **áreas de superfície de água (ha)** de uma **Cidade (município)** de um Estado **ou** de um **Bioma** brasileiro, usando dados do **Projeto MapBiomas Água (Coleção 4)**. Os dados **mensais** serão utilizados por serem mais ricos para modelagem de séries temporais.

---

## Fases e Tarefas

### Fase 0 — Preparação e Decisões Iniciais
- [x] Explorar as abas do arquivo Excel para identificar quais estão disponíveis (Municípios mensais, Biomas, Sub-bacias)
- [x] **Escolher** a Cidade (município) ou Bioma a ser analisado — **Belo Horizonte (MG)** ✅
- [x] Registrar a escolha no fórum da disciplina para evitar conflito com outros grupos *(pendente: publicar no fórum)*
- [x] Revisar o notebook atual (`series_temporais.ipynb`) — reescrito completamente com todos os modelos e critérios

### Fase 1 — Análise Exploratória e Preparação dos Dados
- [ ] Carregar os dados da aba correta (Município mensal ou Bioma mensal)
- [ ] Filtrar a unidade escolhida (Cidade/Bioma selecionado)
- [ ] Criar objeto de série temporal `ts()` com `frequency = 12` (mensal)
- [ ] Plotar a série completa
- [ ] Calcular e plotar o periodograma integrado (`cpgram`)
- [ ] Decompor a série (`decompose` ou `stl`) para identificar tendência e sazonalidade
- [ ] Aplicar o **Teste de Dickey-Fuller Aumentado (ADF)** para verificar estacionariedade
- [ ] Se não estacionária: aplicar diferenciação (`diff`) e re-testar

### Fase 2 — Divisão Treino/Teste
- [ ] Definir o ponto de corte para divisão (sugestão: últimos 2–5 anos como teste; ex. treino até dez/2018, teste jan/2019–dez/2023)
- [ ] Criar `ts_treino` e `ts_teste` com `window()` usando índices mensais `c(ano, mês)`
- [ ] Calcular o horizonte `h = length(ts_teste)` (número de meses no teste)
- [ ] Registrar o ponto de corte escolhido em `DECISOES.md` D003

### Fase 3 — Modelagem (Ajuste dos Modelos)
Ajustar os seguintes modelos na base de **treino**:

- [ ] **SES** — Suavização Exponencial Simples (`ses`)
- [ ] **SEH (Holt)** — Suavização com Tendência (`holt`)
- [ ] **Holt-Winters** — Suavização com Tendência e Sazonalidade (`hw`) *(plenamente aplicável para série mensal — captura ciclo sazonal anual)*
- [ ] **ARIMA / SARIMA** — Metodologia Box-Jenkins (`auto.arima`)
- [ ] **ETS** — Espaço de Estados (`ets`)

Para cada modelo:
- [ ] Apresentar resumo (`summary`) e registrar o **AIC**
- [ ] Plotar o periodograma integrado dos resíduos (`cpgram`)
- [ ] Executar diagnóstico dos resíduos (`checkresiduals`)

### Fase 4 — Comparação e Seleção do Melhor Modelo
- [ ] Calcular o **RMSE** na base de teste com `accuracy(modelo, ts_teste)` para todos os modelos
- [ ] Construir tabela comparativa: Modelo | AIC | RMSE (treino) | RMSE (teste)
- [ ] Identificar o melhor modelo na etapa de modelagem (AIC) e na etapa preditiva (RMSE teste)
- [ ] Verificar se o melhor modelo em AIC também é o melhor em RMSE de previsão

### Fase 5 — Previsão
- [ ] Gerar previsão com o melhor modelo para o horizonte definido
- [ ] Plotar previsão vs. valores reais do período de teste
- [ ] Adicionar intervalos de confiança ao gráfico de previsão

### Fase 6 — Escrita do Artigo Científico
Estrutura seguindo normas ABNT e modelo fornecido pela professora:

- [ ] **Título** — descritivo, referenciando a variável, unidade espacial e período
- [ ] **Resumo** (100–250 palavras, em português)
- [ ] **Abstract** (tradução do resumo para o inglês)
- [ ] **Palavras-chave** (3–5 termos)
- [ ] **1. Introdução** — contexto ambiental/hídrico, revisão de 2–3 artigos científicos relacionados, objetivo do trabalho
- [ ] **2. Metodologia** — descrição dos dados (fonte, período, unidade), pré-processamento, modelos aplicados, critérios de avaliação
- [ ] **3. Resultados** — análise exploratória, resultados dos modelos, tabelas e gráficos
- [ ] **4. Discussão** — comparação entre modelos, interpretação dos resultados no contexto ambiental
- [ ] **5. Considerações Finais** — síntese dos principais achados, limitações, perspectivas
- [ ] **Referências** — citar dados MapBiomas + artigos científicos (normas ABNT)
- [ ] Exportar em `.pdf` e `.docx`

---

## Ordem de Prioridade

1. Resolver a **Fase 0** antes de qualquer código — a escolha da Cidade/Bioma determina tudo
2. Corrigir/reescrever o notebook (`series_temporais.ipynb`) após a decisão
3. Gerar todos os gráficos e tabelas no notebook antes de escrever o artigo
4. Escrever o artigo com base nos resultados do notebook

---

## Entregáveis

| Arquivo | Descrição |
|---------|-----------|
| `series_temporais.ipynb` | Notebook R com toda a análise reproduzível |
| `artigo.docx` | Artigo em formato Word |
| `artigo.pdf` | Artigo em PDF |

---

## Observações Importantes

- O modelo **VAR não é necessário** para este trabalho (série univariada)
- Os dados são **mensais** (`frequency = 12`) — Holt-Winters é plenamente aplicável e deve capturar o ciclo sazonal anual da superfície de água
- A referência dos dados MapBiomas deve constar nas referências do artigo
- Trabalho pode ser **individual** ou em grupos de até 3 pessoas
