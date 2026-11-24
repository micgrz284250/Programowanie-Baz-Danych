-- zadanie 5
-- w przypadku dwóch takich samuch wyników funkcja rank przydziela tą samą pozycję
WITH RANKING AS (
    SELECT
        KOCURY.NR_BANDY AS "Nr bandy",
        NAZWA AS "Nazwa",
        PSEUDO AS "Pseudo",
        PRZYDZIAL_MYSZY + COALESCE(MYSZY_EXTRA, 0) AS "Zjada",
        RANK() OVER (PARTITION BY KOCURY.NR_BANDY ORDER BY PRZYDZIAL_MYSZY + COALESCE(MYSZY_EXTRA, 0) DESC NULLS LAST) AS "Pozycja"
    FROM BANDY
    LEFT JOIN KOCURY ON BANDY.NR_BANDY = KOCURY.NR_BANDY
)
SELECT
    "Nr bandy",
    "Nazwa",
    "Pseudo",
    "Zjada"
FROM RANKING
WHERE "Pozycja" <= 2;

-- zadanie 6
WITH RANKING AS (
    SELECT
        FUNKCJE.FUNKCJA AS "Funkcja",
        KOCURY.PSEUDO AS "Pseudo",
        RANK() OVER (PARTITION BY KOCURY.FUNKCJA ORDER BY PRZYDZIAL_MYSZY + COALESCE(MYSZY_EXTRA, 0) DESC NULLS LAST) AS "Pozycja",
        PRZYDZIAL_MYSZY + COALESCE(MYSZY_EXTRA, 0) AS "Zjada",
        MAX_MYSZY AS "Max myszy",
        MIN_MYSZY AS "Min myszy"
    FROM FUNKCJE
    LEFT JOIN KOCURY ON FUNKCJE.FUNKCJA = KOCURY.FUNKCJA
)
SELECT
    "Funkcja",
    "Pseudo",
    "Zjada",
    CASE
        WHEN "Zjada" IS NULL THEN NULL
        WHEN "Min myszy" <= "Zjada" AND "Zjada" <= "Max myszy" THEN 'W WIDELKACH'
        ELSE 'POWYZEJ WIDELEK'
    END AS "Ocena"
FROM RANKING
WHERE "Pozycja" = 1;

-- zadanie 7
WITH LATA AS (
    SELECT
        EXTRACT(YEAR FROM W_STADKU_OD) AS "Rok",
        COUNT(*) AS "Ile"
    FROM KOCURY
    GROUP BY EXTRACT(YEAR FROM W_STADKU_OD)
)
SELECT
    TO_CHAR("Rok"),
    "Ile"
FROM LATA
-- w celu wybrania lat najbliżej wybieramy:
-- najmniejszą wartość, która jest większa od średniej
-- największą wartość, która jest mniejsza od średniej
-- tym sposobem mamy przedział [max, min] średnia zawiera się w nim
WHERE "Ile" = (SELECT MAX("Ile") FROM LATA WHERE "Ile" < (SELECT AVG("Ile") FROM LATA))
   OR "Ile" = (SELECT MIN("Ile") FROM LATA WHERE "Ile" > (SELECT AVG("Ile") FROM LATA))

UNION

SELECT
    'Srednia',
    ROUND(AVG("Ile"), 7)
FROM LATA
ORDER BY 2;

-- zadanie 8
SELECT
    K1.IMIE AS "Imie",
    TO_CHAR(K1.W_STADKU_OD) || ' <--- NAJMLODSZY STAZEM W BANDZIE ' || NAZWA AS "Wstapil do stadka"
FROM KOCURY K1
JOIN BANDY ON K1.NR_BANDY = BANDY.NR_BANDY
WHERE W_STADKU_OD = (
    SELECT MAX(K2.W_STADKU_OD)
    FROM KOCURY K2
    WHERE K1.NR_BANDY = K2.NR_BANDY
)

UNION

SELECT
    K1.IMIE AS "Imie",
    TO_CHAR(K1.W_STADKU_OD) || ' <--- NAJSTARSZY STAZEM W BANDZIE ' || NAZWA AS "Wstapil do stadka"
FROM KOCURY K1
JOIN BANDY ON K1.NR_BANDY = BANDY.NR_BANDY
WHERE W_STADKU_OD = (
    SELECT MIN(K2.W_STADKU_OD)
    FROM KOCURY K2
    WHERE K1.NR_BANDY = K2.NR_BANDY
)

UNION

SELECT
    K1.IMIE AS "Imie",
    TO_CHAR(K1.W_STADKU_OD) AS "Wstapil do stadka"
FROM KOCURY K1
WHERE K1.W_STADKU_OD > (
    SELECT MIN(K2.W_STADKU_OD)
    FROM KOCURY K2
    WHERE K1.NR_BANDY = K2.NR_BANDY
)
AND K1.W_STADKU_OD < (
    SELECT MAX(K2.W_STADKU_OD)
    FROM KOCURY K2
    WHERE K1.NR_BANDY = K2.NR_BANDY
)

ORDER BY 1;
