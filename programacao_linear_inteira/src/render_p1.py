"""Resolve a Parte 1 por B&B, desenha as arvores e gera tabelas LaTeX."""
import os
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import networkx as nx

import bb
import problems_p1

HERE = os.path.dirname(__file__)
FIGS = os.path.join(HERE, "..", "figs")
GEN = os.path.join(HERE, "..", "relatorio", "gen")
os.makedirs(FIGS, exist_ok=True)
os.makedirs(GEN, exist_ok=True)


def fmt_sol(sol):
    if sol is None:
        return "--"
    return ", ".join(f"{k}={v:.2f}".rstrip("0").rstrip(".") for k, v in sol.items())


def tree_layout(nodes):
    """Layout hierarquico simples: y = -profundidade, x = ordem em folhas."""
    children = {n.id: [] for n in nodes}
    by_id = {n.id: n for n in nodes}
    root = None
    for n in nodes:
        if n.parent is None:
            root = n.id
        else:
            children[n.parent].append(n.id)
    depth = {}

    def setdepth(nid, d):
        depth[nid] = d
        for c in children[nid]:
            setdepth(c, d + 1)
    setdepth(root, 0)

    xpos = {}
    counter = [0]

    def assign(nid):
        ch = children[nid]
        if not ch:
            xpos[nid] = counter[0]
            counter[0] += 1
        else:
            for c in ch:
                assign(c)
            xpos[nid] = sum(xpos[c] for c in ch) / len(ch)
    assign(root)
    return {n.id: (xpos[n.id], -depth[n.id]) for n in nodes}, by_id


COLORS = {
    "inteiro": "#2ca02c",
    "fracionario": "#1f77b4",
    "inviavel": "#d62728",
    "podado": "#ff7f0e",
    None: "#999999",
}


def draw_tree(res, fname, title):
    nodes = [n for n in res["nodes"] if n.step is not None or n.parent is not None]
    # mantem todos os nos criados
    nodes = res["nodes"]
    pos, by_id = tree_layout(nodes)
    G = nx.DiGraph()
    for n in nodes:
        G.add_node(n.id)
        if n.parent is not None:
            G.add_edge(n.parent, n.id)

    fig, ax = plt.subplots(figsize=(max(7, len(nodes) * 0.9), 6))
    nx.draw_networkx_edges(G, pos, ax=ax, edge_color="#888", arrows=False)
    for n in nodes:
        x, y = pos[n.id]
        col = COLORS.get(n.status, "#999999")
        ax.scatter([x], [y], s=1500, c=col, zorder=3, edgecolors="black")
        label = f"N{n.id}"
        if n.step:
            label += f"\n(p{n.step})"
        ax.text(x, y, label, ha="center", va="center", color="white",
                fontsize=8, fontweight="bold", zorder=4)
        # caixa de informacao
        if n.status == "inviavel":
            info = "inviavel"
        elif n.z is not None:
            info = f"z={n.z:.2f}\n{fmt_sol(n.sol)}"
        else:
            info = "(nao explorado)"
        ax.text(x, y - 0.32, info, ha="center", va="top", fontsize=7,
                bbox=dict(boxstyle="round,pad=0.2", fc="#f5f5f5", ec="#ccc"))
        # rotulo do ramo na aresta (proximo ao filho, acima do no)
        if n.parent is not None:
            px, py = pos[n.parent]
            t = 0.70
            lx, ly = px + t * (x - px), py + t * (y - py) + 0.13
            ax.text(lx, ly, n.branch_txt, fontsize=7.5,
                    color="#1a1a1a", ha="center", fontweight="bold",
                    bbox=dict(boxstyle="round,pad=0.15", fc="#fff7e0", ec="#e0c060"))
    ax.set_title(title)
    ax.axis("off")
    plt.tight_layout()
    plt.savefig(os.path.join(FIGS, fname), dpi=140, bbox_inches="tight")
    plt.close()


def latex_table(res, label):
    rows = []
    for n in sorted([x for x in res["nodes"] if x.step], key=lambda a: a.step):
        z = f"{n.z:.3f}" if n.z is not None else "--"
        sol = fmt_sol(n.sol)
        st = {"inteiro": "inteira", "fracionario": "fracion.",
              "inviavel": "inviavel", "podado": "podado"}[n.status]
        ramo = n.branch_txt.replace("<=", "$\\leq$").replace(">=", "$\\geq$")
        note = n.note
        rows.append(f"{n.step} & N{n.id} & {ramo} & {z} & {sol} & {st} & {note} \\\\")
    body = "\n".join(rows)
    tbl = (
        "\\begin{footnotesize}\n"
        "\\begin{longtable}{c c l c l c p{4.2cm}}\n"
        "\\toprule\n"
        "Passo & N\\'o & Ramo & $z_{LP}$ & Solu\\c{c}\\~ao da relaxa\\c{c}\\~ao & Status & Observa\\c{c}\\~ao \\\\\n"
        "\\midrule\n\\endhead\n"
        f"{body}\n"
        "\\bottomrule\n"
        "\\end{longtable}\n"
        "\\end{footnotesize}\n"
    )
    return tbl


def main():
    summary = {}
    for i, fn in enumerate(problems_p1.ALL, start=1):
        pd = fn()
        res = bb.branch_and_bound(pd, max_steps=200)
        draw_tree(res, f"p1_ex{i}_tree.png", pd["name"])
        with open(os.path.join(GEN, f"p1_ex{i}_table.tex"), "w", encoding="utf-8") as f:
            f.write(latex_table(res, f"p1ex{i}"))
        summary[i] = (res["incumbent_z"], res["incumbent_sol"],
                      len([n for n in res["nodes"] if n.step]))
        print(pd["name"], "-> z*=", res["incumbent_z"], res["incumbent_sol"],
              "| nos explorados:", summary[i][2])
    return summary


if __name__ == "__main__":
    main()
