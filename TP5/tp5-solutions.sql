SET AUTOCOMMIT OFF;

-- EXO 1

-- Q1
CREATE TABLE transaction (
    idTransaction  VARCHAR2(44),
    valTransaction NUMBER(10)
);

-- Q2
INSERT INTO transaction VALUES ('T1', 100);
INSERT INTO transaction VALUES ('T2', 200);
INSERT INTO transaction VALUES ('T3', 300);
UPDATE transaction SET valTransaction = 999 WHERE idTransaction = 'T1';
DELETE FROM transaction WHERE idTransaction = 'T2';
ROLLBACK;
SELECT * FROM transaction;

-- Q3
INSERT INTO transaction VALUES ('T4', 400);
INSERT INTO transaction VALUES ('T5', 500);
-- quit sans COMMIT => ROLLBACK implicite

-- Q4
INSERT INTO transaction VALUES ('T6', 600);
-- fermeture brutale => ROLLBACK implicite

-- Q5
INSERT INTO transaction VALUES ('T7', 700);
ALTER TABLE transaction ADD val2transaction NUMBER(10);
ROLLBACK;
-- ALTER TABLE = COMMIT implicite => ROLLBACK sans effet


-- EXO 2

CREATE TABLE vol (
    idVol                 VARCHAR2(44),
    capaciteVol           NUMBER(10),
    nbrPlacesReserveesVol NUMBER(10)
);

CREATE TABLE client (
    idClient                 VARCHAR2(44),
    prenomClient             VARCHAR2(11),
    nbrPlacesReserveesCleint NUMBER(10)
);

INSERT INTO vol    VALUES ('V1', 100, 0);
INSERT INTO client VALUES ('C1', 'Alice', 0);
INSERT INTO client VALUES ('C2', 'Bob', 0);
COMMIT;

-- T1 (S1) : réservation 2 billets pour C1
SELECT nbrPlacesReserveesVol    FROM vol    WHERE idVol    = 'V1';
SELECT nbrPlacesReserveesCleint FROM client WHERE idClient = 'C1';
UPDATE vol    SET nbrPlacesReserveesVol    = nbrPlacesReserveesVol    + 2 WHERE idVol    = 'V1';
UPDATE client SET nbrPlacesReserveesCleint = nbrPlacesReserveesCleint + 2 WHERE idClient = 'C1';
COMMIT;

-- T2 (S2) : réservation 3 billets pour C2
SELECT nbrPlacesReserveesVol    FROM vol    WHERE idVol    = 'V1';
SELECT nbrPlacesReserveesCleint FROM client WHERE idClient = 'C2';
UPDATE vol    SET nbrPlacesReserveesVol    = nbrPlacesReserveesVol    + 3 WHERE idVol    = 'V1';
UPDATE client SET nbrPlacesReserveesCleint = nbrPlacesReserveesCleint + 3 WHERE idClient = 'C2';
COMMIT;

-- READ COMMITTED => mise a jour perdue (vol = 3 au lieu de 5)
-- SERIALIZABLE => ORA-08177 pour l'une des deux transactions
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- r1(d) w2(d) w2(d') C2 w1(d') C1
-- S1: SELECT * FROM vol WHERE idVol = 'V1';
-- S2: UPDATE vol SET nbrPlacesReserveesVol = 10 WHERE idVol = 'V1';
-- S2: UPDATE vol SET nbrPlacesReserveesVol = 20 WHERE idVol = 'V1';
-- S2: COMMIT;
-- S1: UPDATE vol SET nbrPlacesReserveesVol = 15 WHERE idVol = 'V1';
-- S1: COMMIT;