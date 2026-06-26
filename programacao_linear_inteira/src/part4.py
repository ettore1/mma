"""Parte 4 - Minima arborescencia (Prim/Kruskal) e Fluxo maximo (Edmonds-Karp)."""
import os
from collections import deque
import numpy as np
# compatibilidade NumPy 2.0 x networkx 2.8 (np.alltrue/sometrue removidos)
if not hasattr(np, "alltrue"):
    np.alltrue = np.all
if not hasattr(np, "sometrue"):
    np.sometrue = np.any
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import networkx as nx

HERE = os.path.dirname(__file__)
FIGS = os.path.join(HERE, "..", "figs")
GEN = os.path.join(HERE, "..", "relatorio", "gen")
os.makedirs(FIGS, exist_ok=True)
os.makedirs(GEN, exist_ok=True)


# =========================================================================
#  GRAFOS DE ENTRADA  (pesos transcritos das figuras do enunciado)
# =========================================================================
# Exercicio 1 - grafo nao-direcionado (12 nos)
EX1_EDGES = [
    (11, 7, 6), (11, 12, 11), (12, 10, 13),
    (7, 6, 22), (7, 10, 9),
    (6, 3, 5), (6, 5, 7),
    (3, 1, 7), (3, 5, 8), (3, 4, 6),
    (10, 8, 4), (10, 9, 7),
    (8, 9, 7), (8, 5, 10),
    (5, 9, 20), (5, 4, 9),
    (9, 4, 8),
    (4, 2, 4), (1, 2, 10),
]
EX1_POS = {
    11: (0.6, 6.2), 7: (1.7, 5.3), 12: (0.0, 5.0), 6: (3.2, 4.4),
    10: (1.4, 3.7), 3: (4.2, 2.9), 5: (3.0, 2.4), 8: (1.4, 1.9),
    9: (2.3, 1.5), 1: (5.2, 2.1), 4: (3.4, 1.0), 2: (4.2, 0.3),
}

# Exercicio 2 - grafo nao-direcionado (15 nos)
EX2_EDGES = [
    (11, 15, 5), (11, 12, 11), (11, 7, 3), (12, 7, 6), (12, 10, 13),
    (15, 14, 7), (7, 10, 19), (7, 14, 3), (7, 6, 22),
    (14, 6, 7), (14, 13, 4), (10, 8, 14), (10, 9, 17), (10, 5, 10),
    (8, 9, 13), (9, 5, 11), (6, 5, 7), (6, 3, 9), (6, 13, 5),
    (5, 3, 8), (5, 4, 9), (3, 13, 5), (3, 1, 7), (3, 4, 6),
    (13, 1, 8), (4, 2, 4), (1, 2, 10),
]
EX2_POS = {
    11: (4.3, 7.0), 15: (5.6, 6.9), 12: (3.3, 6.6), 7: (4.4, 5.6),
    14: (6.2, 5.4), 10: (2.6, 4.8), 6: (5.2, 4.4), 8: (1.0, 4.3),
    13: (7.2, 4.4), 5: (3.6, 3.9), 3: (5.0, 3.6), 9: (2.0, 3.5),
    4: (4.6, 2.6), 1: (6.6, 3.0), 2: (4.0, 1.8),
}

# Exercicio 5 - grafo DIRECIONADO (15 nos) - capacidades da TABELA do enunciado
EX5_ARCS = [
    (1, 2, 13), (1, 5, 46), (1, 9, 40), (1, 10, 92),
    (2, 3, 27), (2, 6, 80), (2, 14, 88),
    (3, 4, 90), (3, 7, 79), (3, 8, 26), (3, 11, 37), (3, 12, 43), (3, 13, 42),
    (4, 15, 44),
    (5, 3, 82), (5, 6, 43), (5, 14, 46),
    (6, 4, 80), (6, 7, 56), (6, 8, 38), (6, 11, 74), (6, 12, 81), (6, 13, 35),
    (7, 15, 34),
    (8, 15, 63),
    (9, 3, 47), (9, 6, 77), (9, 14, 13),
    (10, 3, 19), (10, 6, 60), (10, 14, 70),
    (11, 15, 57),
    (12, 15, 74),
    (13, 15, 62),
    (14, 4, 63), (14, 7, 15), (14, 8, 59), (14, 11, 90), (14, 12, 74), (14, 13, 45),
]
EX5_POS = {
    7: (5.0, 7.2), 10: (2.8, 6.0), 13: (7.2, 6.0), 5: (1.8, 4.8),
    14: (4.6, 4.9), 8: (7.2, 4.9), 1: (0.6, 3.8), 3: (5.0, 3.8),
    15: (8.4, 3.8), 9: (1.8, 2.7), 6: (4.0, 2.8), 4: (6.2, 2.2),
    2: (2.4, 1.3), 11: (5.0, 0.8), 12: (6.6, 1.0),
}


# =========================================================================
#  MINIMA ARVORE GERADORA
# =========================================================================
def kruskal(nodes, edges):
    parent = {v: v for v in nodes}

    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    log, tree, total = [], [], 0
    for u, v, w in sorted(edges, key=lambda e: e[2]):
        ru, rv = find(u), find(v)
        if ru != rv:
            parent[ru] = rv
            tree.append((u, v, w))
            total += w
            log.append((u, v, w, "ACEITA", f"une componentes {{{u}}} e {{{v}}}"))
        else:
            log.append((u, v, w, "rejeita", "formaria ciclo"))
    return tree, total, log


def prim(nodes, edges, start):
    adj = {v: [] for v in nodes}
    for u, v, w in edges:
        adj[u].append((w, v))
        adj[v].append((w, u))
    visited = {start}
    log, tree, total = [], [], 0
    while len(visited) < len(nodes):
        best = None
        for u in visited:
            for w, v in adj[u]:
                if v not in visited and (best is None or w < best[2]):
                    best = (u, v, w)
        if best is None:
            break
        u, v, w = best
        visited.add(v)
        tree.append((u, v, w))
        total += w
        log.append((u, v, w, "ACEITA", f"adiciona no {v} via aresta ({u},{v})"))
    return tree, total, log


def draw_graph(nodes, edges, pos, fname, title, tree=None, directed=False,
               flow=None):
    G = (nx.DiGraph() if directed else nx.Graph())
    for e in edges:
        G.add_edge(e[0], e[1], w=e[2])
    fig, ax = plt.subplots(figsize=(9, 7))
    tree_set = set()
    if tree:
        tree_set = {frozenset((u, v)) for u, v, _ in tree}
    ecolors, widths = [], []
    for u, v in G.edges():
        if frozenset((u, v)) in tree_set:
            ecolors.append("#d62728"); widths.append(3.2)
        else:
            ecolors.append("#bbbbbb"); widths.append(1.3)
    nx.draw_networkx_edges(G, pos, ax=ax, edge_color=ecolors, width=widths,
                           arrows=directed, arrowsize=18,
                           connectionstyle="arc3,rad=0.0")
    nx.draw_networkx_nodes(G, pos, ax=ax, node_color="#2ec4c4",
                           node_size=600, edgecolors="black")
    nx.draw_networkx_labels(G, pos, ax=ax, font_size=10, font_weight="bold")
    if flow is not None:
        labels = {(u, v): f"{flow.get((u,v),0)}/{d['w']}"
                  for u, v, d in G.edges(data=True)}
    else:
        labels = {(u, v): d["w"] for u, v, d in G.edges(data=True)}
    nx.draw_networkx_edge_labels(G, pos, edge_labels=labels, ax=ax,
                                 font_size=8, label_pos=0.5,
                                 bbox=dict(boxstyle="round,pad=0.1",
                                           fc="white", ec="none"))
    ax.set_title(title, fontweight="bold")
    ax.axis("off")
    plt.tight_layout()
    plt.savefig(os.path.join(FIGS, fname), dpi=140, bbox_inches="tight")
    plt.close()


# =========================================================================
#  FLUXO MAXIMO - EDMONDS-KARP
# =========================================================================
def edmonds_karp(nodes, arcs, source, sink):
    cap = {}
    adj = {v: set() for v in nodes}
    for u, v, c in arcs:
        cap[(u, v)] = cap.get((u, v), 0) + c
        cap.setdefault((v, u), 0)
        adj[u].add(v); adj[v].add(u)
    flow = {k: 0 for k in cap}
    steps, maxflow = [], 0

    while True:
        # BFS no grafo residual
        prev = {source: None}
        q = deque([source])
        while q:
            u = q.popleft()
            if u == sink:
                break
            for v in adj[u]:
                if v not in prev and cap[(u, v)] - flow[(u, v)] > 1e-9:
                    prev[v] = u
                    q.append(v)
        if sink not in prev:
            break
        # gargalo
        path, v = [], sink
        while prev[v] is not None:
            path.append((prev[v], v)); v = prev[v]
        path.reverse()
        bottleneck = min(cap[e] - flow[e] for e in path)
        for (u, v) in path:
            flow[(u, v)] += bottleneck
            flow[(v, u)] -= bottleneck
        maxflow += bottleneck
        steps.append(([source] + [v for _, v in path], bottleneck, maxflow))

    pos_flow = {k: f for k, f in flow.items() if f > 0}
    return maxflow, pos_flow, steps


def fmt_path(p):
    return " -> ".join(str(x) for x in p)


def w(fn, txt):
    with open(os.path.join(GEN, fn), "w", encoding="utf-8") as f:
        f.write(txt)


def mst_table(log, algo):
    rows = []
    for i, (u, v, wt, dec, obs) in enumerate(log, 1):
        d = "\\textbf{aceita}" if dec == "ACEITA" else "rejeita"
        rows.append(f"{i} & ({u},{v}) & {wt} & {d} & {obs} \\\\")
    head = "Ordem & Aresta & Peso & Decis\\~ao & Coment\\'ario \\\\" if algo == "k" \
        else "Itera\\c{c}\\~ao & Aresta & Peso & Decis\\~ao & Coment\\'ario \\\\"
    return ("\\begin{footnotesize}\n\\begin{longtable}{c c c c p{5.5cm}}\n\\toprule\n"
            + head + "\n\\midrule\n\\endhead\n" + "\n".join(rows)
            + "\n\\bottomrule\n\\end{longtable}\n\\end{footnotesize}\n")


def flow_table(steps):
    rows = []
    for i, (p, b, acc) in enumerate(steps, 1):
        rows.append(f"{i} & ${fmt_path(p).replace('->', r'\to ')}$ & {b} & {acc} \\\\")
    return ("\\begin{footnotesize}\n\\begin{longtable}{c l c c}\n\\toprule\n"
            "Itera\\c{c}\\~ao & Caminho aumentante (BFS) & Gargalo & Fluxo acumulado \\\\\n"
            "\\midrule\n\\endhead\n" + "\n".join(rows)
            + "\n\\bottomrule\n\\end{longtable}\n\\end{footnotesize}\n")


# =========================================================================
def main():
    out = {}

    # ---- Ex1 MST ----
    n1 = list(range(1, 13))
    t_k, z_k, log_k = kruskal(n1, EX1_EDGES)
    t_p, z_p, log_p = prim(n1, EX1_EDGES, start=1)
    draw_graph(n1, EX1_EDGES, EX1_POS, "p4_ex1_grafo.png",
               "Parte 4 - Ex.1: grafo de entrada")
    draw_graph(n1, EX1_EDGES, EX1_POS, "p4_ex1_mst.png",
               f"Parte 4 - Ex.1: minima arvore geradora (custo = {z_k})", tree=t_k)
    out["ex1"] = (z_k, z_p, log_k, log_p, t_k)
    w("p4_ex1_kruskal.tex", mst_table(log_k, "k"))
    w("p4_ex1_prim.tex", mst_table(log_p, "p"))
    print("Ex1 MST: Kruskal =", z_k, "| Prim =", z_p)

    # ---- Ex2 MST ----
    n2 = list(range(1, 16))
    t_k2, z_k2, log_k2 = kruskal(n2, EX2_EDGES)
    t_p2, z_p2, log_p2 = prim(n2, EX2_EDGES, start=1)
    draw_graph(n2, EX2_EDGES, EX2_POS, "p4_ex2_grafo.png",
               "Parte 4 - Ex.2: grafo de entrada")
    draw_graph(n2, EX2_EDGES, EX2_POS, "p4_ex2_mst.png",
               f"Parte 4 - Ex.2: minima arvore geradora (custo = {z_k2})", tree=t_k2)
    out["ex2"] = (z_k2, z_p2, log_k2, log_p2, t_k2)
    w("p4_ex2_kruskal.tex", mst_table(log_k2, "k"))
    w("p4_ex2_prim.tex", mst_table(log_p2, "p"))
    print("Ex2 MST: Kruskal =", z_k2, "| Prim =", z_p2)

    # ---- Ex5 Max Flow ----
    n5 = list(range(1, 16))
    mf, fl, steps = edmonds_karp(n5, EX5_ARCS, 1, 15)
    draw_graph(n5, EX5_ARCS, EX5_POS, "p4_ex5_grafo.png",
               "Parte 4 - Ex.5: grafo direcionado (capacidades)", directed=True)
    draw_graph(n5, EX5_ARCS, EX5_POS, "p4_ex5_fluxo.png",
               f"Parte 4 - Ex.5: fluxo maximo = {mf} (fluxo/capacidade)",
               directed=True, flow=fl)
    out["ex5"] = (mf, fl, steps)
    w("p4_ex5_steps.tex", flow_table(steps))
    print("Ex5 Max Flow: valor =", mf)
    for p, b, acc in steps:
        print("  caminho", fmt_path(p), "gargalo", b, "acumulado", acc)

    return out


if __name__ == "__main__":
    main()
