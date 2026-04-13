SET SERVEROUTPUT ON;

-- EXO 1

-- Q1
DECLARE
    a NUMBER := &a;
    b NUMBER := &b;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Somme : ' || (a + b));
END;
/

-- Q2
DECLARE
    n NUMBER := &n;
BEGIN
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(n || ' x ' || i || ' = ' || (n * i));
    END LOOP;
END;
/

-- Q3
CREATE OR REPLACE FUNCTION puissance(x NUMBER, n NUMBER) RETURN NUMBER IS
BEGIN
    IF n = 0 THEN RETURN 1;
    ELSE RETURN x * puissance(x, n - 1);
    END IF;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('2^10 = ' || puissance(2, 10));
END;
/

-- Q4
CREATE TABLE resultatFactoriel (
    n        NUMBER(10),
    resultat NUMBER(20)
);

DECLARE
    n      NUMBER := &n;
    result NUMBER := 1;
BEGIN
    FOR i IN 1..n LOOP
        result := result * i;
    END LOOP;
    INSERT INTO resultatFactoriel VALUES (n, result);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(n || '! = ' || result);
END;
/

-- Q5
CREATE TABLE resultatsFactoriels (
    n        NUMBER(10),
    resultat NUMBER(20)
);

DECLARE
    result NUMBER := 1;
BEGIN
    FOR i IN 1..20 LOOP
        result := result * i;
        INSERT INTO resultatsFactoriels VALUES (i, result);
    END LOOP;
    COMMIT;
END;
/


-- EXO 2

CREATE TABLE emp (
    matr    NUMBER(10)   NOT NULL,
    nom     VARCHAR2(50) NOT NULL,
    sal     NUMBER(7,2),
    adresse VARCHAR2(96),
    dep     NUMBER(10)   NOT NULL,
    CONSTRAINT emp_pk PRIMARY KEY (matr)
);

INSERT INTO emp VALUES (1, 'Alice', 3000, '10 rue de Paris', 92000);
INSERT INTO emp VALUES (2, 'Bob',   2000, '5 avenue Voltaire', 75000);
INSERT INTO emp VALUES (3, 'Carol', 3500, '8 boulevard Hugo', 92000);
INSERT INTO emp VALUES (4, 'Dave',  1800, '2 rue Lafayette', 75000);
COMMIT;

-- Q1
DECLARE
    v_employe emp%ROWTYPE;
BEGIN
    v_employe.matr    := 5;
    v_employe.nom     := 'Youcef';
    v_employe.sal     := 2500;
    v_employe.adresse := 'avenue de la Republique';
    v_employe.dep     := 92002;
    INSERT INTO emp VALUES v_employe;
END;
/

-- Q2
DECLARE
    v_nb_lignes NUMBER;
BEGIN
    DELETE FROM emp WHERE dep = 10;
    v_nb_lignes := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('v_nb_lignes : ' || v_nb_lignes);
END;
/

-- Q3
DECLARE
    v_salaire emp.sal%TYPE;
    v_total   emp.sal%TYPE := 0;
    CURSOR c_salaires IS SELECT sal FROM emp;
BEGIN
    OPEN c_salaires;
    LOOP
        FETCH c_salaires INTO v_salaire;
        EXIT WHEN c_salaires%NOTFOUND;
        IF v_salaire IS NOT NULL THEN
            v_total := v_total + v_salaire;
        END IF;
    END LOOP;
    CLOSE c_salaires;
    DBMS_OUTPUT.PUT_LINE('Total : ' || v_total);
END;
/

-- Q4
DECLARE
    v_salaire emp.sal%TYPE;
    v_total   emp.sal%TYPE := 0;
    v_count   NUMBER := 0;
    CURSOR c_salaires IS SELECT sal FROM emp;
BEGIN
    OPEN c_salaires;
    LOOP
        FETCH c_salaires INTO v_salaire;
        EXIT WHEN c_salaires%NOTFOUND;
        IF v_salaire IS NOT NULL THEN
            v_total := v_total + v_salaire;
            v_count := v_count + 1;
        END IF;
    END LOOP;
    CLOSE c_salaires;
    DBMS_OUTPUT.PUT_LINE('Moyenne : ' || (v_total / v_count));
END;
/

-- Q5a : somme avec FOR IN
DECLARE
    v_total emp.sal%TYPE := 0;
    CURSOR c_salaires IS SELECT sal FROM emp;
BEGIN
    FOR v_emp IN c_salaires LOOP
        IF v_emp.sal IS NOT NULL THEN
            v_total := v_total + v_emp.sal;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total (FOR IN) : ' || v_total);
END;
/

-- Q5b : moyenne avec FOR IN
DECLARE
    v_total emp.sal%TYPE := 0;
    v_count NUMBER := 0;
    CURSOR c_salaires IS SELECT sal FROM emp;
BEGIN
    FOR v_emp IN c_salaires LOOP
        IF v_emp.sal IS NOT NULL THEN
            v_total := v_total + v_emp.sal;
            v_count := v_count + 1;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Moyenne (FOR IN) : ' || (v_total / v_count));
END;
/

-- Q6
DECLARE
    CURSOR c(p_dep emp.dep%TYPE) IS
        SELECT dep, nom FROM emp WHERE dep = p_dep;
BEGIN
    FOR v_employe IN c(92000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 1 : ' || v_employe.nom);
    END LOOP;
    FOR v_employe IN c(75000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 2 : ' || v_employe.nom);
    END LOOP;
END;
/


-- EXO 3

CREATE TABLE client (
    idClient               VARCHAR2(44),
    prenomClient           VARCHAR2(50),
    nbrPlacesReservees     NUMBER(10)
);

CREATE OR REPLACE PACKAGE pkg_client AS
    PROCEDURE ajouterClient(p_id VARCHAR2, p_prenom VARCHAR2, p_places NUMBER);
    PROCEDURE ajouterClient(p_id VARCHAR2, p_prenom VARCHAR2);
END pkg_client;
/

CREATE OR REPLACE PACKAGE BODY pkg_client AS

    PROCEDURE ajouterClient(p_id VARCHAR2, p_prenom VARCHAR2, p_places NUMBER) IS
    BEGIN
        INSERT INTO client VALUES (p_id, p_prenom, p_places);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Client ' || p_prenom || ' ajoute avec ' || p_places || ' places.');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : id ' || p_id || ' existe deja.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
    END;

    PROCEDURE ajouterClient(p_id VARCHAR2, p_prenom VARCHAR2) IS
    BEGIN
        INSERT INTO client VALUES (p_id, p_prenom, 0);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Client ' || p_prenom || ' ajoute.');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : id ' || p_id || ' existe deja.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
    END;

END pkg_client;
/

BEGIN
    pkg_client.ajouterClient('C001', 'Alice', 2);
    pkg_client.ajouterClient('C002', 'Bob');
END;
/
