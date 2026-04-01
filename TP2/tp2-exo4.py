import itertools


def printDependencies(F):
    for alpha, beta in F:
        print("\t", alpha, "-->", beta)


def printRelations(T):
    for R in T:
        print("\t", R)


def powerSet(inputset):
    _result = []
    for r in range(1, len(inputset) + 1):
        _result += map(set, itertools.combinations(inputset, r))
    return _result


def computeAttributeClosure(F, K):
    K_plus, size = set(K), 0
    while size != len(K_plus):
        size = len(K_plus)
        for alpha, beta in F:
            if alpha.issubset(K_plus):
                K_plus.update(beta)
    return K_plus


def computeDependenciesClosure(F):
    R = set()
    for alpha, beta in F:
        R.update(alpha | beta)
    F_plus = []
    for K in powerSet(R):
        for beta in powerSet(computeAttributeClosure(F, K)):
            F_plus.append([K, beta])
    return F_plus


def isDependency(F, alpha, beta):
    return beta.issubset(computeAttributeClosure(F, alpha))


def isSuperKey(F, R, K):
    return R.issubset(computeAttributeClosure(F, K))


def isCandidateKey(F, R, K):
    if not isSuperKey(F, R, K):
        return False
    for A in K:
        _K1 = set(K)
        _K1.discard(A)
        if isSuperKey(F, R, _K1):
            return False
    return True


def computeAllCandidateKeys(F, R):
    result = []
    for K in powerSet(R):
        if isCandidateKey(F, R, K):
            result.append(K)
    return result


def computeAllSuperKeys(F, R):
    result = []
    for K in powerSet(R):
        if isSuperKey(F, R, K):
            result.append(K)
    return result


def computeOneCandidateKey(F, R):
    K = set(R)
    while not isCandidateKey(F, R, K):
        for A in K:
            if isSuperKey(F, R, K.difference({A})):
                K.remove(A)
                break
    return K


def isBCNFRelation(F, R):
    for K in powerSet(R):
        K_plus = computeAttributeClosure(F, K)
        Y = K_plus.difference(K)
        if not R.issubset(K_plus) and not Y.isdisjoint(R):
            return False, [K, Y & R]
    return True, [{}, {}]


def isBCNFRelations(F, T):
    for R in T:
        result, witness = isBCNFRelation(F, R)
        if result == False:
            return False, R
    return True, {}


def computeBCNFDecomposition(F, T):
    OUT, size = list(T), 0
    while size != len(OUT):
        size = len(OUT)
        for R in OUT:
            _isR_BCNF, [alpha, beta] = isBCNFRelation(F, R)
            if _isR_BCNF == False:
                if alpha | beta not in OUT:
                    OUT.append(alpha | beta)
                if R.difference(beta) not in OUT:
                    OUT.append(R.difference(beta))
                OUT.remove(R)
                break
    return OUT


# == TEST ==
if __name__ == "__main__":
    R = {'A', 'B', 'C', 'G', 'H', 'I'}
    F = [
        [{'A'}, {'B'}],
        [{'A'}, {'C'}],
        [{'C', 'G'}, {'H'}],
        [{'C', 'G'}, {'I'}],
        [{'B'}, {'H'}]
    ]

    print("Dependances :")
    printDependencies(F)

    print("\nFermeture de A :", computeAttributeClosure(F, {'A'}))
    print("Cles candidates :", computeAllCandidateKeys(F, R))
    print("BCNF ?", isBCNFRelation(F, R))
    print("Decomposition BCNF :", computeBCNFDecomposition(F, [R]))