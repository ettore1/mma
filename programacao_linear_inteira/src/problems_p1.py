"""Definicao dos 4 problemas da Parte 1 (Branch-and-Bound)."""
import pulp


def ex1():
    return {
        "name": "Parte 1 - Exercicio 1",
        "sense": pulp.LpMaximize,
        "vars": ["x1", "x2", "x3", "x4"],
        "int_vars": ["x1", "x2", "x3", "x4"],
        "obj": {"x1": 1, "x2": 5, "x3": 9, "x4": 5},
        "constraints": [
            ({"x1": 1, "x2": 3, "x3": 9, "x4": 6}, "<=", 16),
            ({"x1": 6, "x2": 6, "x4": 7}, "<=", 19),
            ({"x1": 7, "x2": 8, "x3": 18, "x4": 3}, "<=", 44),
        ],
    }


def ex2():
    return {
        "name": "Parte 1 - Exercicio 2",
        "sense": pulp.LpMaximize,
        "vars": ["x1", "x2", "x3", "x4"],
        "int_vars": ["x1", "x2", "x4"],          # x3 continua
        "obj": {"x1": 7, "x2": 9, "x3": 1, "x4": 6},
        "constraints": [
            ({"x1": 8, "x2": 2, "x3": 4, "x4": 2}, "<=", 16),
            ({"x1": 4, "x2": 8, "x3": 2}, "<=", 20),
            ({"x1": 7, "x3": 6, "x4": 2}, "<=", 11),
        ],
    }


def ex3():
    return {
        "name": "Parte 1 - Exercicio 3",
        "sense": pulp.LpMinimize,
        "vars": ["x1", "x2", "x3"],
        "int_vars": ["x2", "x3"],                # x1 continua
        "obj": {"x1": 3, "x2": 4, "x3": 3},
        "constraints": [
            ({"x1": 3, "x2": 2, "x3": 2}, ">=", 13),
            ({"x1": 2, "x2": 5, "x3": 3}, ">=", 15),
            ({"x1": 2, "x2": 1, "x3": 2}, ">=", 9),
        ],
    }


def ex4():
    return {
        "name": "Parte 1 - Exercicio 4",
        "sense": pulp.LpMinimize,
        "vars": ["x1", "x2", "x3"],
        "int_vars": ["x1", "x3"],                # x2 continua
        "obj": {"x1": 2, "x2": 3, "x3": 5},
        "constraints": [
            ({"x1": 1, "x2": 2, "x3": 3}, ">=", 7),
            ({"x1": 3, "x2": 2, "x3": 3}, ">=", 11),
        ],
    }


ALL = [ex1, ex2, ex3, ex4]
