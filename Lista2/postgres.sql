-- zadanie 1
SELECT
    imie_wroga AS wrog,
    opis_incydentu AS przewina
FROM wrogowie_kocurow
WHERE extract(year from data_incydentu) = 2009;

-- zadanie 2
SELECT
    imie AS imie,
    funkcja AS funckja,
    w_stadku_od AS z_nami_od
FROM kocury
WHERE plec = 'D'
  AND w_stadku_od BETWEEN '2005-09-01' AND '2007-07-31';

-- zadanie 3
SELECT
    imie_wroga AS wrog,
    gatunek AS gatunek,
    stopien_wrogosci AS stopien_wrogosci
FROM wrogowie
WHERE lapowka IS NULL
ORDER BY stopien_wrogosci;

-- zadanie 4
SELECT
    imie || ' zwany ' || pseudo || ' (fun. ' || funkcja || ') lowi myszki w bandzie ' || nr_bandy || ' od ' || w_stadku_od AS wszystko_o_kocurach
FROM kocury
WHERE plec = 'M'
ORDER BY w_stadku_od DESC, pseudo;

-- zadanie 5
SELECT
    pseudo AS pseudo,
    position('A' IN pseudo) AS a,
    position('L' IN pseudo) AS l,
    replace(replace(pseudo, 'L', '%'), 'A', '#') AS "po_wymianie_a_na_#_oraz_l_na_%"
FROM kocury
WHERE position('A' IN pseudo) > 0
  AND position('L' IN pseudo) > 0;

-- zadanie 6
SELECT
    imie AS imie,
    w_stadku_od AS w_stadku,
    round(przydzial_myszy / 1.1) AS zjadal,
    (w_stadku_od + interval '6 months')::date AS podwyzka,
    przydzial_myszy AS zjada
FROM kocury
WHERE w_stadku_od <= DATE '2024-07-17' - interval '15 years'
  AND extract(month from w_stadku_od) BETWEEN 3 AND 9;

-- zadanie 7
SELECT
    imie AS imie,
    przydzial_myszy * 3 AS myszy_kwartalnie,
    coalesce(myszy_extra, 0) * 3 AS kwartalne_dodatki
FROM kocury
WHERE przydzial_myszy >= 55
  AND przydzial_myszy > 2 * coalesce(myszy_extra, 0)
ORDER BY przydzial_myszy DESC;

-- zadanie 8
SELECT
    imie AS imie,
    CASE
        WHEN (przydzial_myszy + coalesce(myszy_extra, 0)) * 12 > 660 THEN ((przydzial_myszy + coalesce(myszy_extra, 0)) * 12)::text
        WHEN (przydzial_myszy + coalesce(myszy_extra, 0)) * 12 = 660 THEN 'limit'
        ELSE 'ponizej 660'
    END AS zjada_rocznie
FROM kocury
ORDER BY imie;

-- zadanie 9
SELECT
    pseudo || ' - ' || CASE
        WHEN count(*) = 1 THEN 'unikalny'
        ELSE 'nieunikalny'
        END AS unikalnosc_atr_PSEUDO
FROM kocury
GROUP BY pseudo;

SELECT
    szef || ' - ' || CASE
        WHEN count(*) = 1 THEN 'unikalny'
        ELSE 'nieunikalny'
        END AS unikalnosc_atr_SZEF
FROM kocury
WHERE szef IS NOT NULL
GROUP BY szef;

-- zadanie 10
SELECT
    pseudo AS pseudonim,
    count(*) AS liczba_wrogow
FROM wrogowie_kocurow
GROUP BY pseudo
HAVING count(*) >= 2;