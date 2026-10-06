"""Independent finite semantic smoke check, starting from actual semigroups.

No helpers from the envelope or analytic scripts are used. This cannot prove
the universal algebraic reduction; it is meant to expose translation mistakes.
"""
from collections import Counter
from hashlib import sha256
from heapq import heappop, heappush
from itertools import combinations
from math import comb, gcd
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]


def minimal_generators(gs):
    if gcd(*gs) != 1:
        return False
    reachable = [False] * (gs[-1] + 1)
    reachable[0] = True
    for g in gs:
        if reachable[g]:
            return False
        for n in range(g, len(reachable)):
            reachable[n] |= reachable[n - g]
    return True


def apery(gs):
    m = gs[0]
    dist = [None] * m
    dist[0] = 0
    pending = [(0, 0)]
    while pending:
        value, residue = heappop(pending)
        if value != dist[residue]:
            continue
        for g in gs[1:]:
            new = value + g
            r = new % m
            if dist[r] is None or new < dist[r]:
                dist[r] = new
                heappush(pending, (new, r))
    assert None not in dist
    return sorted(dist)


def check(gs):
    m, w = gs[0], gs[-1] - gs[0]
    ap = apery(gs)
    # A monomial basis of R/(t^m) is indexed by Apéry elements.
    # Its maximal factorization lengths give the associated graded HF.
    order = {0: 0}
    for value in ap[1:]:
        predecessors = [order[value - g] for g in gs[1:] if value - g in order]
        assert predecessors, (gs, value)
        order[value] = 1 + max(predecessors)
    hf = Counter(order.values())
    assert sum(hf.values()) == m and hf[0] == 1 and hf[1] == 3
    standard = set()
    total = 0
    for d in range(max(hf) + 1):
        total += hf[d]
        assert total <= 1 + d * w, (gs, d, total)
        # Smallest monomials in lex order x > y > z form the standard suffix.
        remaining = hf[d]
        for i in range(d + 1):
            if not remaining:
                break
            for j in range(d - i + 1):
                if not remaining:
                    break
                standard.add((i, j, d - i - j))
                remaining -= 1
        assert remaining == 0
    assert len(standard) == m
    for mon in standard:
        for axis in range(3):
            if mon[axis]:
                pred = list(mon)
                pred[axis] -= 1
                assert tuple(pred) in standard, (gs, 'not an order ideal', mon)
    border = set()
    for mon in standard:
        for axis in range(3):
            nxt = list(mon)
            nxt[axis] += 1
            if tuple(nxt) not in standard:
                border.add(tuple(nxt))
    generators = []
    for mon in border:
        minimal = True
        for axis in range(3):
            if mon[axis]:
                pred = list(mon)
                pred[axis] -= 1
                minimal &= tuple(pred) in standard
        if minimal:
            generators.append(mon)
    a = 0
    while (a, 0, 0) in standard:
        a += 1
    assert a >= 2
    columns = [sum(i == col and k == 0 for i, j, k in standard) for col in range(a)]
    ell = sum(columns)
    assert len(generators) == a + 1 + ell, (gs, generators, columns)
    assert sum(n * (n + 1) for n in columns) <= 2 * (1 + (columns[0] - 1) * w)
    assert a + 1 + ell < comb(w + 1, 2), (gs, a, ell)
    assert a + 2 * ell <= 2 * comb(w + 1, 3)
    assert ell <= 3 * comb(w + 1, 4)
    return {'generators': gs, 'width': w, 'alpha': a, 'section_length': ell,
            'lex_minimal_generators': len(generators), 'strict_target': comb(w + 1, 2) - 1}


def main():
    cases = []
    for m in range(4, 41):
        for w in range(4, 9):
            for a, b in combinations(range(1, w), 2):
                gs = (m, m + a, m + b, m + w)
                if minimal_generators(gs):
                    cases.append(gs)
    for m in (101, 257, 1009):
        for w in (4, 7, 12):
            cases.append((m, m + 1, m + 2, m + w))
    rows = [check(gs) for gs in cases]
    result = {
        'status': 'Finite semantic cross-check passed; not a universal proof.',
        'method': 'Apéry via Dijkstra; maximal factorization orders; independent lex reconstruction; border generators.',
        'count': len(rows), 'all_pass': True,
        'small_range': '4 <= multiplicity <= 40, 4 <= width <= 8, all minimal coprime four-generator sets within each interval',
        'larger_multiplicities': [101, 257, 1009],
        'source_sha256': sha256(Path(__file__).read_bytes()).hexdigest(),
        'rows': rows,
    }
    (ROOT / 'results/semigroup_semantic_check.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'checked': len(rows), 'all_pass': True, 'scope': result['status']}))


if __name__ == '__main__':
    main()
