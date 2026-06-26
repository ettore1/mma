"""
Motor de Branch-and-Bound (B&B) para problemas de Programacao Linear Inteira.

A relaxacao linear de cada no e resolvida com o solver CBC (via PuLP).
Estrategia de busca: BUSCA EM PROFUNDIDADE (depth-first).
Regra de ramificacao: variavel inteira de menor indice com valor fracionario.
Ordem dos filhos: ramo do PISO (x <= floor) explorado primeiro.

Cada "passo" corresponde a resolver a relaxacao de UM no.
"""
import math
import pulp

EPS = 1e-6


class Node:
    def __init__(self, nid, parent, branch_txt, bounds):
        self.id = nid
        self.parent = parent
        self.branch_txt = branch_txt   # restricao que gerou o no (ex.: "x2 <= 1")
        self.bounds = bounds           # dict var -> (lo, hi) limites adicionais
        self.step = None               # ordem em que o no foi resolvido
        self.status = None             # 'inviavel' | 'fracionario' | 'inteiro' | 'podado'
        self.z = None
        self.sol = None
        self.note = ""                 # comentario (poda etc.)


def solve_relaxation(prob_data, bounds):
    """Resolve a relaxacao linear com limites adicionais dados por `bounds`."""
    sense = prob_data["sense"]               # pulp.LpMaximize / LpMinimize
    names = prob_data["vars"]                # lista de nomes de variaveis
    obj = prob_data["obj"]                   # dict nome -> coef
    constraints = prob_data["constraints"]   # lista de (dict coef, sinal, rhs)

    m = pulp.LpProblem("relax", sense)
    x = {}
    for n in names:
        lo, hi = bounds.get(n, (0, None))
        x[n] = pulp.LpVariable(n, lowBound=lo, upBound=hi, cat="Continuous")
    m += pulp.lpSum(obj.get(n, 0) * x[n] for n in names)
    for coef, sign, rhs in constraints:
        expr = pulp.lpSum(coef.get(n, 0) * x[n] for n in names)
        if sign == "<=":
            m += expr <= rhs
        elif sign == ">=":
            m += expr >= rhs
        else:
            m += expr == rhs
    status = m.solve(pulp.PULP_CBC_CMD(msg=0))
    if pulp.LpStatus[status] != "Optimal":
        return None, None
    sol = {n: x[n].value() for n in names}
    return pulp.value(m.objective), sol


def first_fractional(sol, int_vars):
    """Retorna (nome, valor) da 1a variavel inteira com valor fracionario."""
    for n in int_vars:
        v = sol[n]
        if abs(v - round(v)) > 1e-4:
            return n, v
    return None, None


def branch_and_bound(prob_data, max_steps=5):
    sense = prob_data["sense"]
    int_vars = prob_data["int_vars"]
    maximize = (sense == pulp.LpMaximize)

    incumbent_z = None
    incumbent_sol = None
    nodes = []
    counter = [0]

    def new_node(parent, branch_txt, bounds):
        nd = Node(counter[0], parent, branch_txt, bounds)
        counter[0] += 1
        nodes.append(nd)
        return nd

    root = new_node(None, "raiz (LP)", {})
    stack = [root]
    step = 0

    while stack and step < max_steps:
        nd = stack.pop()
        step += 1
        nd.step = step
        z, sol = solve_relaxation(prob_data, nd.bounds)

        if z is None:
            nd.status = "inviavel"
            nd.note = "Poda por inviabilidade"
            continue
        nd.z, nd.sol = z, sol

        # poda por limitante (bound)
        if incumbent_z is not None:
            if (maximize and z <= incumbent_z + EPS) or \
               (not maximize and z >= incumbent_z - EPS):
                nd.status = "podado"
                nd.note = f"Poda por limitante (z={z:.3f} nao supera incumbente {incumbent_z:.3f})"
                continue

        bn, bv = first_fractional(sol, int_vars)
        if bn is None:
            nd.status = "inteiro"
            # atualiza incumbente
            if incumbent_z is None or (maximize and z > incumbent_z) or \
               (not maximize and z < incumbent_z):
                incumbent_z, incumbent_sol = z, dict(sol)
                nd.note = "Nova solucao incumbente (inteira)"
            else:
                nd.note = "Solucao inteira (nao melhora incumbente)"
            continue

        nd.status = "fracionario"
        f = math.floor(bv)
        c = math.ceil(bv)
        # filho do PISO  (x <= floor)
        b_lo = dict(nd.bounds)
        lo, hi = b_lo.get(bn, (0, None))
        b_lo[bn] = (lo, f)
        child_lo = new_node(nd.id, f"{bn} <= {f}", b_lo)
        # filho do TETO  (x >= ceil)
        b_hi = dict(nd.bounds)
        lo, hi = b_hi.get(bn, (0, None))
        b_hi[bn] = (c, hi)
        child_hi = new_node(nd.id, f"{bn} >= {c}", b_hi)
        nd.note = f"Ramifica em {bn} = {bv:.3f}"
        # empilha TETO depois PISO -> PISO sai primeiro (LIFO)
        stack.append(child_hi)
        stack.append(child_lo)

    # nos criados mas nao explorados (ficaram na pilha)
    explored = {n.id for n in nodes if n.step is not None}
    pendentes = [n for n in nodes if n.id not in explored]

    return {
        "nodes": nodes,
        "incumbent_z": incumbent_z,
        "incumbent_sol": incumbent_sol,
        "pendentes": pendentes,
    }
