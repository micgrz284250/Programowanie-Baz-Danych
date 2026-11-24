-- zadanie 5
-- w przypadku dwoch takich samych wynikow funkcja rank przydziela ta sama pozycje
WITH ranking AS (
    SELECT
        bandy.nr_bandy AS nr_bandy,
        nazwa AS nazwa,
        pseudo AS pseudo,
        przydzial_myszy + coalesce(myszy_extra, 0) AS zjada,
        rank() OVER (
            PARTITION BY bandy.nr_bandy
            ORDER BY przydzial_myszy + coalesce(myszy_extra, 0) DESC NULLS LAST
        ) AS pozycja
    FROM bandy
    LEFT JOIN kocury ON bandy.nr_bandy = kocury.nr_bandy
)
SELECT
    nr_bandy,
    nazwa,
    pseudo,
    zjada
FROM ranking
WHERE pozycja <= 2
ORDER BY nr_bandy, zjada DESC NULLS LAST, pseudo;

-- zadanie 6
WITH ranking AS (
    SELECT
        funkcje.funkcja AS funkcja,
        kocury.pseudo AS pseudo,
        rank() OVER (
            PARTITION BY funkcje.funkcja
            ORDER BY przydzial_myszy + coalesce(myszy_extra, 0) DESC NULLS LAST
        ) AS pozycja,
        przydzial_myszy + coalesce(myszy_extra, 0) AS zjada,
        max_myszy AS max_myszy,
        min_myszy AS min_myszy
    FROM funkcje
    LEFT JOIN kocury ON funkcje.funkcja = kocury.funkcja
)
SELECT
    funkcja,
    pseudo,
    zjada,
    CASE
        WHEN zjada IS NULL THEN NULL
        WHEN zjada > max_myszy THEN 'POWYZEJ WIDELEK'
        WHEN zjada < min_myszy THEN 'PONIZEJ WIDELEK'
        ELSE 'W WIDELKACH'
    END AS ocena
FROM ranking
WHERE pozycja = 1
ORDER BY funkcja;

-- zadanie 7
WITH lata AS (
    SELECT
        EXTRACT(YEAR FROM w_stadku_od) AS rok,
        count(*) AS ile
    FROM kocury
    GROUP BY EXTRACT(YEAR FROM w_stadku_od)
)
SELECT
    rok::TEXT AS rok,
    ile AS liczba_wstapien
FROM lata
-- w celu wybrania lat najblizej wybieramy:
-- najmniejsza wartosc, ktora jest wieksza od sredniej
-- najwieksza wartosc, ktora jest mniejsza od sredniej
-- tym sposobem mamy przedzial [max, min] srednia zawiera sie w nim
WHERE ile = (SELECT max(ile) FROM lata WHERE ile < (SELECT avg(ile) FROM lata))
   OR ile = (SELECT min(ile) FROM lata WHERE ile > (SELECT avg(ile) FROM lata))

UNION

SELECT
    'Srednia',
    round(avg(ile), 7)
FROM lata
ORDER BY 2;

-- zadanie 8
-- wybieramy najpierw najmłodszy staż
SELECT
    k1.imie AS imie,
    to_char(k1.w_stadku_od, 'YYYY-MM-DD') || ' <--- NAJMLODSZY STAZEM W BANDZIE ' || nazwa AS wstapil_do_stadka
FROM kocury k1
JOIN bandy ON k1.nr_bandy = bandy.nr_bandy
WHERE w_stadku_od = (
    SELECT max(k2.w_stadku_od)
    FROM kocury k2
    WHERE k1.nr_bandy = k2.nr_bandy
)

UNION

-- wybieramy najpierw najstarszy staż
SELECT
    k1.imie AS imie,
    to_char(k1.w_stadku_od, 'YYYY-MM-DD') || ' <--- NAJSTARSZY STAZEM W BANDZIE ' || nazwa AS wstapil_do_stadka
FROM kocury k1
JOIN bandy ON k1.nr_bandy = bandy.nr_bandy
WHERE w_stadku_od = (
    SELECT min(k2.w_stadku_od)
    FROM kocury k2
    WHERE k1.nr_bandy = k2.nr_bandy
)

UNION

-- dokładamy resztę kotów
SELECT
    k1.imie AS imie,
    to_char(k1.w_stadku_od, 'YYYY-MM-DD') AS wstapil_do_stadka
FROM kocury k1
WHERE k1.w_stadku_od > (
    SELECT min(k2.w_stadku_od)
    FROM kocury k2
    WHERE k1.nr_bandy = k2.nr_bandy
)
AND k1.w_stadku_od < (
    SELECT max(k2.w_stadku_od)
    FROM kocury k2
    WHERE k1.nr_bandy = k2.nr_bandy
)

ORDER BY 1;
