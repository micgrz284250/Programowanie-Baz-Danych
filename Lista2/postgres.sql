-- zadanie 1
SELECT
    imie_wroga AS "WROG",
    opis_incydentu AS "PRZEWINA"
FROM wrogowie_kocurow
WHERE EXTRACT(YEAR FROM data_incydentu) = 2009;

-- zadanie 2
SELECT
    imie AS "IMIE",
    funkcja AS "FUNKCJA",
    w_stadku_od AS "Z NAMI OD"
FROM Kocury
WHERE plec = 'D'
  AND w_stadku_od BETWEEN '2005-09-01' AND '2007-07-31';

-- zadanie 3
SELECT
    imie_wroga AS "WROG",
    gatunek AS "GATUNEK",
    stopien_wrogosci AS "STOPIEN WROGOSCI"
FROM wrogowie
WHERE lapowka IS NULL
ORDER BY stopien_wrogosci;

-- zadanie 4
SELECT
    imie || ' zwany ' || pseudo || ' (fun. ' || funkcja || ') lowi myszki w bandzie ' || nr_bandy || ' od ' || w_stadku_od AS "WSZYSTKO O KOCURACH"
FROM Kocury
WHERE plec = 'M'
ORDER BY w_stadku_od DESC, pseudo;

-- zadanie 5
SELECT
    pseudo AS "PSEUDO",
    POSITION('A' IN pseudo) AS "A",
    POSITION('L' IN pseudo) AS "L",
    REGEXP_REPLACE(REGEXP_REPLACE(pseudo, 'A', '#'), 'L', '%') AS "PO WYMIANIE A NA # ORAZ L NA %"
FROM Kocury
WHERE POSITION('A' IN pseudo) > 0
  AND POSITION('L' IN pseudo) > 0;

-- zadanie 6
SELECT
    imie AS "IMIE",
    w_stadku_od AS "W STADKU",
    ROUND(przydzial_myszy / 1.1) AS "ZJADAL",
    (w_stadku_od + INTERVAL '6 months')::DATE AS "PODWYZKA",
    przydzial_myszy AS "ZJADA"
FROM Kocury
WHERE w_stadku_od <= DATE '2024-07-17' - INTERVAL '15 years'
  AND EXTRACT(MONTH FROM w_stadku_od) BETWEEN 3 AND 9;

-- zadanie 7
SELECT
    imie AS "IMIE",
    przydzial_myszy * 3 AS "MYSZY KWARTALNIE",
    COALESCE(myszy_extra, 0) * 3 AS "KWARTALNE DODATKI"
FROM Kocury
WHERE przydzial_myszy >= 55
  AND przydzial_myszy > 2 * COALESCE(myszy_extra, 0)
ORDER BY przydzial_myszy DESC;