"""Parte 3 - Transporte, transbordo e designacao (resolvidos com PuLP/CBC)."""
import os
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pulp

HERE = os.path.dirname(__file__)
FIGS = os.path.join(HERE, "..", "figs")
GEN = os.path.join(HERE, "..", "relatorio", "gen")
os.makedirs(FIGS, exist_ok=True)
os.makedirs(GEN, exist_ok=True)


def solve_transport(cost, supply, demand, integer=False):
    """min sum c_ij x_ij ; sum_j x_ij <= s_i ; sum_i x_ij = d_j  (oferta>=demanda)."""
    m = len(supply)
    n = len(demand)
    cat = "Integer" if integer else "Continuous"
    prob = pulp.LpProblem("transp", pulp.LpMinimize)
    x = [[pulp.LpVariable(f"x_{i}_{j}", lowBound=0, cat=cat)
          for j in range(n)] for i in range(m)]
    prob += pulp.lpSum(cost[i][j] * x[i][j] for i in range(m) for j in range(n))
    for i in range(m):
        prob += pulp.lpSum(x[i][j] for j in range(n)) <= supply[i]
    for j in range(n):
        prob += pulp.lpSum(x[i][j] for i in range(m)) == demand[j]
    prob.solve(pulp.PULP_CBC_CMD(msg=0))
    X = np.array([[x[i][j].value() for j in range(n)] for i in range(m)])
    return X, pulp.value(prob.objective)


def solve_assignment(cost):
    n = len(cost)
    prob = pulp.LpProblem("assign", pulp.LpMinimize)
    x = [[pulp.LpVariable(f"x_{i}_{j}", cat="Binary") for j in range(n)]
         for i in range(n)]
    prob += pulp.lpSum(cost[i][j] * x[i][j] for i in range(n) for j in range(n))
    for i in range(n):
        prob += pulp.lpSum(x[i][j] for j in range(n)) == 1
    for j in range(n):
        prob += pulp.lpSum(x[i][j] for i in range(n)) == 1
    prob.solve(pulp.PULP_CBC_CMD(msg=0))
    X = np.array([[int(round(x[i][j].value())) for j in range(n)]
                  for i in range(n)])
    return X, pulp.value(prob.objective)


def save_matrix_fig(X, rows, cols, fname, title, fmt="{:.0f}", highlight=True):
    fig, ax = plt.subplots(figsize=(1.2 + 0.9 * len(cols), 1.0 + 0.5 * len(rows)))
    ax.axis("off")
    cell = [[fmt.format(X[i][j]) if X[i][j] > 1e-6 else "." for j in range(len(cols))]
            for i in range(len(rows))]
    tbl = ax.table(cellText=cell, rowLabels=rows, colLabels=cols,
                   cellLoc="center", loc="center")
    tbl.auto_set_font_size(False)
    tbl.set_fontsize(10)
    tbl.scale(1, 1.4)
    if highlight:
        for i in range(len(rows)):
            for j in range(len(cols)):
                if X[i][j] > 1e-6:
                    tbl[(i + 1, j)].set_facecolor("#cfe8cf")
    ax.set_title(title, fontweight="bold")
    plt.tight_layout()
    plt.savefig(os.path.join(FIGS, fname), dpi=140, bbox_inches="tight")
    plt.close()


def w(fn, txt):
    with open(os.path.join(GEN, fn), "w", encoding="utf-8") as f:
        f.write(txt)


results = {}

# ---------------- Exercicio 1 ----------------
cost1 = [[10, 7, 5, 6], [12, 7, 6, 4], [13, 6, 3, 5]]
sup1 = [220, 180, 230]
dem1 = [150, 165, 210, 90]
X1, z1 = solve_transport(cost1, sup1, dem1)
save_matrix_fig(X1, ["Fab.1", "Fab.2", "Fab.3"],
                ["Merc.1", "Merc.2", "Merc.3", "Merc.4"],
                "p3_ex1_sol.png", f"Ex.1 - Plano otimo (custo = R$ {z1:.0f})")
results["ex1"] = (X1, z1)
print("Ex1: custo =", z1)
print(X1)

# ---------------- Exercicio 2 ----------------
# linhas = locais (demanda de pneus), colunas = revendedores (oferta)
cost2 = [[70, 64, 68], [74, 62, 65], [62, 68, 64], [62, 72, 66]]
need2 = [4000, 8000, 3000, 5000]      # por local (demanda)
avail2 = [12000, 6000, 4000]          # por revendedor (oferta)
# modelo: linhas=revendedor(oferta), colunas=local(demanda) -> transpor custo
costT = [[cost2[l][r] for l in range(4)] for r in range(3)]
X2, z2 = solve_transport(costT, avail2, need2)
save_matrix_fig(X2, ["Rev.A", "Rev.B", "Rev.C"],
                ["Curitiba", "Londrina", "Cascavel", "C.Mourao"],
                "p3_ex2_sol.png", f"Ex.2 - Compras otimas (custo = R$ {z2:.0f})")
results["ex2"] = (X2, z2)
print("Ex2: custo =", z2)
print(X2)

# ---------------- Exercicio 3 ----------------
cost3 = [[92, 89, 90], [91, 91, 95], [87, 90, 92]]
sup3 = [320, 270, 150]     # milhares de galoes
dem3 = [100, 180, 300]
X3, z3 = solve_transport(cost3, sup3, dem3)
save_matrix_fig(X3, ["Forn.1", "Forn.2", "Forn.3"],
                ["Aerop.1", "Aerop.2", "Aerop.3"],
                "p3_ex3_sol.png", f"Ex.3 - Aquisicao otima (custo = $ {z3*1000:.0f}k em milhares gal)")
results["ex3"] = (X3, z3)
print("Ex3: custo =", z3, "(x1000 gal) -> $", z3, "milhares de unidade-galao")
print(X3)

# ---------------- Exercicio 4 ----------------
dist4 = [
    [10, 22, 29, 45, 11, 31, 42, 61, 36, 21, 45],
    [25, 35, 17, 38, 9, 17, 65, 45, 42, 5, 41],
    [18, 19, 22, 29, 24, 54, 39, 78, 51, 14, 38],
]
cost4 = [[0.5 * d for d in row] for row in dist4]   # $0,50/ton/km
cap4 = [500, 750, 400]
dem4 = [112, 85, 138, 146, 77, 89, 101, 215, 53, 49, 153]
X4, z4 = solve_transport(cost4, cap4, dem4)
save_matrix_fig(X4, ["C1", "C2", "C3"],
                [f"W{j+1}" for j in range(11)],
                "p3_ex4_sol.png", f"Ex.4 - Programa otimo (custo = $ {z4:.2f})")
results["ex4"] = (X4, z4)
print("Ex4: custo =", z4)
print(X4)

# ---------------- Exercicio 5 ----------------
cost5 = [
    [13, 22, 19, 21, 16, 20],
    [18, 17, 24, 18, 22, 27],
    [20, 22, 23, 24, 17, 31],
    [14, 19, 13, 30, 23, 22],
    [21, 14, 17, 25, 15, 23],
    [17, 23, 18, 20, 16, 24],
]
X5, z5 = solve_assignment(cost5)
save_matrix_fig(X5, [f"Trab.{i+1}" for i in range(6)],
                [f"Tar.{j+1}" for j in range(6)],
                "p3_ex5_sol.png", f"Ex.5 - Designacao otima (tempo = {z5:.0f} min)")
results["ex5"] = (X5, z5)
print("Ex5: tempo total =", z5)
print(X5)
# detalhe da designacao
assign = [(i + 1, int(np.argmax(X5[i])) + 1, cost5[i][int(np.argmax(X5[i]))])
          for i in range(6)]
print("Designacao:", assign)
