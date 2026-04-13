## TP5 - Conclusions

### Exercice 1

**Q3** - Quitter sqlplus sans COMMIT provoque un ROLLBACK implicite. Les données ne sont pas sauvegardées.

**Q4** - Une fermeture brutale provoque également un ROLLBACK implicite.

**Q5** - Tout DDL (ALTER, CREATE, DROP) déclenche un COMMIT implicite en Oracle. Le ROLLBACK qui suit n'a aucun effet.

**Définitions**
- **Session** : connexion d'un utilisateur à Oracle, peut contenir plusieurs transactions en série.
- **Transaction** : suite d'opérations SQL se terminant par COMMIT ou ROLLBACK.
- **COMMIT** : valide définitivement les modifications.
- **ROLLBACK** : annule toutes les modifications depuis le dernier COMMIT.

---

### Exercice 2

**READ COMMITTED** - Une transaction ne voit que les données committées. Deux transactions peuvent lire la même valeur, la modifier chacune et valider : la dernière écrase la première → mise à jour perdue. T1 et T2 lisent `nbrPlacesReserveesVol = 0`, T1 écrit 2, T2 écrit 3, résultat : 3 au lieu de 5 → incohérence.

**SERIALIZABLE** - Oracle rejette une transaction si une donnée qu'elle a lue a été modifiée entre-temps (`ORA-08177`).

**Oracle vs 2PL** - Oracle utilise la MVCC : chaque transaction travaille sur un snapshot sans poser de verrous en lecture, contrairement au 2PL classique qui pose des verrous dès la lecture.