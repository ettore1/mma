# Lista de Exercícios — Programação Linear Inteira (CEMMA)

Resolução da lista da disciplina **Programação Linear Inteira**
(Prof. Franklin Angelo Krukoski, Junho/2026).

Para cada uma das 4 partes são entregues **mais de 3 exercícios** (mínimo exigido).

## Estrutura

```
src/                 código-fonte Python
  bb.py              motor de Branch-and-Bound (relaxação via PuLP/CBC)
  problems_p1.py     os 4 problemas da Parte 1
  render_p1.py       desenha as árvores B&B e gera tabelas LaTeX
  part3.py           transporte/designação (PuLP) + figuras das soluções
  part4.py           Prim, Kruskal e Edmonds-Karp (NetworkX) + figuras
notebooks/           cadernos Jupyter (um por parte computacional)
figs/                figuras geradas (.png)
relatorio/
  main.tex           documento LaTeX com todas as resoluções
  main.pdf           >>> PDF final para entrega <<<
  gen/               fragmentos .tex gerados automaticamente
```

## O que foi resolvido

| Parte | Tema | Exercícios entregues |
|-------|------|----------------------|
| 1 | Árvore Branch-and-Bound (busca em profundidade) | 1, 2, 3, 4 |
| 2 | Formulação de modelos de PLI | 1, 2, 4, 5, 6 |
| 3 | Transporte / designação (solver) | 1, 2, 3, 4, 5 |
| 4 | Mínima arborescência (Prim/Kruskal) e Fluxo máximo (Edmonds-Karp) | 1, 2, 5 |

## Como reproduzir

```bash
pip install pulp networkx matplotlib numpy

# 1) Gerar figuras e tabelas
python src/render_p1.py
python src/part3.py
python src/part4.py

# 2) Compilar o PDF
cd relatorio
pdflatex main.tex && pdflatex main.tex
```

Os notebooks em `notebooks/` reproduzem os mesmos resultados de forma interativa.

## Principais resultados

- **Parte 1:** Ex1 z\*=20 (1,2,1,0); Ex2 z\*=289/6 (0,2,1/6,5); Ex3 z\*=17 (5/3,0,4); Ex4 z\*=11,5 (2,2.5,0).
- **Parte 3:** Ex1 R$ 3.625; Ex2 R$ 1.272.000; Ex3 US$ 51.990.000; Ex4 $ 16.678,50; Ex5 99 min.
- **Parte 4:** MST Ex1 = 74, Ex2 = 89; Fluxo máximo Ex5 = 191 (corte mínimo na fonte).
