## Exercice 2

### Q1 — R(A, B, C), F = {A→B, B→C}

Fermeture de A : A+ = {A, B, C} → A est une clé candidate.
B→C viole BCNF (B n'est pas une super-clé).

Décomposition :
- R1(B, C) avec F1 = {B→C}
- R2(A, B) avec F2 = {A→B}

Les deux sont en BCNF. Forme la plus avancée : **BCNF**.

---

### Q2 — R(A, B, C), F = {A→C, A→B}

Fermeture de A : A+ = {A, B, C} → A est la seule clé candidate.
Toutes les DF ont A comme déterminant, A est super-clé → **déjà en BCNF**.

---

### Q3 — R(A, B, C), F = {AB→C, C→B}

Clés candidates :
- AB+ = {A, B, C} → AB est super-clé
- AC+ = {A, B, C} → AC est super-clé (via C→B)
- AB et AC sont minimaux → deux clés candidates : {A,B} et {A,C}

C→B viole BCNF (C n'est pas une super-clé).

Décomposition :
- R1(B, C) avec F1 = {C→B} → en BCNF
- R2(A, C) avec F2 = {} → en BCNF

Forme la plus avancée : **BCNF**.

---

## Exercice 3

### Q1 — R(A,B,C,D,E), F = {A→B,C ; C,D→E ; B→D ; E→A}

En appliquant les règles d'Armstrong (réflexivité, augmentation, transitivité) :

1. A → B         (donné)
2. A → C         (donné)
3. CD → E        (donné)
4. B → D         (donné)
5. E → A         (donné)
6. A → D         (transitivité : A→B, B→D)
7. A → BC        (union : A→B, A→C)
8. A → BD        (union : A→B, A→D)
9. A → BCD       (union)
10. A → BCDE     (transitivité : A→CD, CD→E)
11. A → ABCDE    (réflexivité + fermeture)
12. E → B        (transitivité : E→A, A→B)
13. E → C        (transitivité : E→A, A→C)
14. E → D        (transitivité : E→B, B→D)
15. E → ABCDE    (fermeture de E)
16. CD → A       (transitivité : CD→E, E→A)
17. CD → B       (transitivité : CD→A, A→B)
18. CD → ABCDE   (fermeture)

---

### Q2 — R(A,B,C,D,E,F), F = {A→B,C,D ; BC→D,E ; B→D ; D→A}

#### (a) Fermetures

**B+ :**
- B → D  (donné)
- D → A  (donné)
- A → B, C, D
- On obtient : B+ = {A, B, C, D, E} (via B→D→A→B,C,D et avec BC→E car B+⊇{B,C})
- B+ = {A, B, C, D, E}

**{A,B}+ :**
- A → B, C, D
- B → D
- BC → D, E  (B et C dans la fermeture)
- D → A
- {A,B}+ = {A, B, C, D, E}

#### (b) {A,F} est une super-clé

{A,F}+ :
- A → B, C, D
- D → A
- BC → D, E
- On obtient {A,F}+ = {A, B, C, D, E, F} = R → **{A,F} est une super-clé**.

#### (c) BCNF ?

B → D : B+ = {A,B,C,D,E}, B n'est pas une super-clé de R (F absent) → **violation de BCNF**.

Décomposition :
- R1(A, B, C, D, E) avec les DF restreintes → vérifier si BCNF
- R2(B, F) 

Dans R1 : D→A, B→D, A→B,C,D, BC→E → clé candidate = {B} ou {A} ou {D}
  - B+ dans R1 = {A,B,C,D,E} = R1 → B est super-clé de R1 ✓
  - D→A : D+ = {A,B,C,D,E} = R1 → D est super-clé ✓
  - BC→E : BC+ = {A,B,C,D,E} = R1 → BC est super-clé ✓
  
R1 est en BCNF. R2(B,F) est triviale → en BCNF.

**Décomposition finale : R1(A,B,C,D,E) et R2(B,F).**

---

### Q3 — Perte d'information

#### (a) R1(A,B,C) et R2(A,D,E) — sans perte

L'attribut commun est A. Il faut montrer que A est une clé de R1 ou R2.
Si A → B,C (d'après F : A→B,C,D), alors A est une super-clé de R1.
La décomposition est **sans perte** (la jointure sur A redonne R).

#### (b) R1(A,B,C) et R2(C,D,E) — avec perte

L'attribut commun est C. C n'est pas une clé de R1 ni de R2 (C ne détermine rien dans F).
La jointure sur C peut produire des tuples parasites → **décomposition avec perte**.