-- zadanie 9
SELECT
    kocury.pseudo AS do_przeczolgania,
    bandy.nazwa AS nazwa_bandy
FROM kocury
JOIN bandy ON kocury.nr_bandy = bandy.nr_bandy
JOIN funkcje ON kocury.funkcja = funkcje.funkcja
WHERE NOT EXISTS (
    SELECT p.szef
    FROM kocury p
    WHERE p.szef = kocury.pseudo
    )
  AND EXISTS (
    SELECT wrogowie_kocurow.pseudo
    FROM wrogowie_kocurow
    WHERE wrogowie_kocurow.pseudo = kocury.pseudo
    )
  AND kocury.przydzial_myszy >= funkcje.min_myszy + (funkcje.max_myszy - funkcje.min_myszy) / 3;

-- zadanie 10
WITH srednie AS (
    SELECT
        funkcje.funkcja AS funkcja,
        round(avg(przydzial_myszy + coalesce(myszy_extra, 0))) AS srednie
    FROM funkcje
    LEFT JOIN kocury ON funkcje.funkcja = kocury.funkcja
    WHERE funkcje.funkcja != 'SZEFUNIO'
    GROUP BY funkcje.funkcja
)
SELECT
    funkcja,
    srednie AS srednio_najw_i_najm_myszy
FROM srednie
WHERE srednie = (SELECT min(srednie) FROM srednie)
   OR srednie = (SELECT max(srednie) FROM srednie);

-- zadanie 11
-- ze zlaczeniem ale bez podzapytan
SELECT
    k1.imie AS imie,
    k1.przydzial_myszy + coalesce(k1.myszy_extra, 0) AS zjada,
    k1.nr_bandy AS nr_bandy,
    avg(k2.przydzial_myszy + coalesce(k2.myszy_extra, 0)) AS srednia_bandy
FROM kocury k1
JOIN kocury k2 ON k1.nr_bandy = k2.nr_bandy
WHERE k1.plec = 'M'
GROUP BY k1.pseudo, k1.imie, k1.przydzial_myszy, k1.myszy_extra, k1.nr_bandy
HAVING k1.przydzial_myszy + coalesce(k1.myszy_extra, 0) <= avg(k2.przydzial_myszy + coalesce(k2.myszy_extra, 0));

-- ze zlaczeniem i z jedynym podzapytaniem w klauzurze FROM
SELECT
    k.imie AS imie,
    k.przydzial_myszy + coalesce(k.myszy_extra, 0) AS zjada,
    k.nr_bandy AS nr_bandy,
    s.srednia AS srednia_bandy
FROM kocury k
JOIN (
    SELECT
        nr_bandy,
        avg(przydzial_myszy + coalesce(myszy_extra, 0)) AS srednia
    FROM kocury
    GROUP BY nr_bandy
) s ON k.nr_bandy = s.nr_bandy
WHERE k.plec = 'M'
  AND k.przydzial_myszy + coalesce(k.myszy_extra, 0) <= s.srednia;

-- bez zlaczen i z dwoma podzapytaniami: w klauzurach SELECT i WHERE
SELECT
    k1.imie AS imie,
    k1.przydzial_myszy + coalesce(k1.myszy_extra, 0) AS zjada,
    k1.nr_bandy AS nr_bandy,
    (
        SELECT avg(k2.przydzial_myszy + coalesce(k2.myszy_extra, 0))
        FROM kocury k2
        WHERE k1.nr_bandy = k2.nr_bandy
    ) AS srednia_bandy
FROM kocury k1
WHERE k1.plec = 'M'
  AND k1.przydzial_myszy + coalesce(k1.myszy_extra, 0) <= (
        SELECT avg(k2.przydzial_myszy + coalesce(k2.myszy_extra, 0))
        FROM kocury k2
        WHERE k1.nr_bandy = k2.nr_bandy
    );

-- zadanie 12
-- agregacja warunkowa z CASE
SELECT
    CASE
        WHEN k.plec = 'D' THEN b.nazwa
        ELSE ' '
    END AS nazwa_bandy,
    CASE k.plec
        WHEN 'D' THEN 'Kotka'
        ELSE 'Kocor'
    END AS plec,
    count(*) AS ile,
    sum(CASE WHEN k.funkcja = 'SZEFUNIO' THEN k.przydzial_myszy + coalesce(k.myszy_extra, 0) ELSE 0 END) AS szefunio,
    sum(CASE WHEN k.funkcja = 'BANDZIOR' THEN k.przydzial_myszy + coalesce(k.myszy_extra, 0) ELSE 0 END) AS bandzior,
    sum(CASE WHEN k.funkcja = 'LOWCZY' THEN k.przydzial_myszy + coalesce(k.myszy_extra, 0) ELSE 0 END) AS lowczy,
    sum(CASE WHEN k.funkcja = 'LAPACZ' THEN k.przydzial_myszy + coalesce(k.myszy_extra, 0) ELSE 0 END) AS lapacz,
    sum(CASE WHEN k.funkcja = 'KOT' THEN k.przydzial_myszy + coalesce(k.myszy_extra, 0) ELSE 0 END) AS kot,
    sum(CASE WHEN k.funkcja = 'MILUSIA' THEN k.przydzial_myszy + coalesce(k.myszy_extra, 0) ELSE 0 END) AS milusia,
    sum(CASE WHEN k.funkcja = 'DZIELCZY' THEN k.przydzial_myszy + coalesce(k.myszy_extra, 0) ELSE 0 END) AS dzielczy,
    sum(k.przydzial_myszy + coalesce(k.myszy_extra, 0)) AS suma
FROM kocury k
JOIN bandy b ON k.nr_bandy = b.nr_bandy
GROUP BY b.nazwa, k.plec
ORDER BY b.nazwa, k.plec;

-- odpowiednik PIVOT w PostgreSQL klauzula FILTER
SELECT
    CASE
        WHEN k.plec = 'D' THEN b.nazwa
        ELSE ' '
    END AS nazwa_bandy,
    CASE k.plec
        WHEN 'D' THEN 'Kotka'
        ELSE 'Kocor'
    END AS plec,
    count(*) AS ile,
    coalesce(sum(k.przydzial_myszy + coalesce(k.myszy_extra, 0)) FILTER (WHERE k.funkcja = 'SZEFUNIO'), 0) AS szefunio,
    coalesce(sum(k.przydzial_myszy + coalesce(k.myszy_extra, 0)) FILTER (WHERE k.funkcja = 'BANDZIOR'), 0) AS bandzior,
    coalesce(sum(k.przydzial_myszy + coalesce(k.myszy_extra, 0)) FILTER (WHERE k.funkcja = 'LOWCZY'), 0) AS lowczy,
    coalesce(sum(k.przydzial_myszy + coalesce(k.myszy_extra, 0)) FILTER (WHERE k.funkcja = 'LAPACZ'), 0) AS lapacz,
    coalesce(sum(k.przydzial_myszy + coalesce(k.myszy_extra, 0)) FILTER (WHERE k.funkcja = 'KOT'), 0) AS kot,
    coalesce(sum(k.przydzial_myszy + coalesce(k.myszy_extra, 0)) FILTER (WHERE k.funkcja = 'MILUSIA'), 0) AS milusia,
    coalesce(sum(k.przydzial_myszy + coalesce(k.myszy_extra, 0)) FILTER (WHERE k.funkcja = 'DZIELCZY'), 0) AS dzielczy,
    sum(k.przydzial_myszy + coalesce(k.myszy_extra, 0)) AS suma
FROM kocury k
JOIN bandy b ON k.nr_bandy = b.nr_bandy
GROUP BY b.nazwa, k.plec
ORDER BY b.nazwa, k.plec;
