-- Wypisać koty, które mialy jako jedyne ze swojej bandy incydent z danym gatunkiem wroga
SELECT DISTINCT
    k.pseudo,
    k.nr_bandy,
    w.gatunek
FROM kocury k
JOIN wrogowie_kocurow wk ON k.pseudo = wk.pseudo
JOIN wrogowie w ON wk.imie_wroga = w.imie_wroga
WHERE w.gatunek IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM kocury k2
      JOIN wrogowie_kocurow wk2 ON k2.pseudo = wk2.pseudo
      JOIN wrogowie w2 ON wk2.imie_wroga = w2.imie_wroga
      WHERE k2.nr_bandy = k.nr_bandy
        AND w2.gatunek = w.gatunek
        AND k2.pseudo != k.pseudo
  );

-- Wypisać drzewa z hierarchii kotów, które mają co najmniej dwa koty i ich suma przydziałów jest większa niż 200, jakoś tak
WITH RECURSIVE hierarchia AS (
    SELECT
        pseudo AS korzen,
        pseudo AS pseudonim,
        przydzial_myszy + coalesce(myszy_extra, 0) AS zjada,
        1 AS poziom
    FROM kocury

    UNION ALL

    SELECT
        h.korzen,
        k.pseudo,
        k.przydzial_myszy + coalesce(k.myszy_extra, 0),
        h.poziom + 1
    FROM kocury k
    JOIN hierarchia h ON k.szef = h.pseudonim
)
SELECT
    korzen AS szef,
    count(*) AS liczba_kotow,
    sum(zjada) AS suma_przydzialow
FROM hierarchia
GROUP BY korzen
HAVING count(*) >= 2
   AND sum(zjada) > 200;

-- Wypisać bandy, w których występują co najmniej dwa koty (ponadprzeciętne), których całkowity przydział myszy jest
-- większy niż średnia przydziału całkowitego dla kotów o tej samej płci i funkcji
WITH ponadprzecietne AS (
    SELECT
        k.nr_bandy,
        k.przydzial_myszy + coalesce(k.myszy_extra, 0) AS zjada,
        avg(k.przydzial_myszy + coalesce(k.myszy_extra, 0)) over (partition by k.plec, k.funkcja) AS srednia_grupy
    FROM kocury k
)
SELECT
    b.nr_bandy,
    b.nazwa,
    count(*) AS liczba_ponadprzecietnych
FROM ponadprzecietne p
JOIN bandy b ON p.nr_bandy = b.nr_bandy
WHERE p.zjada > p.srednia_grupy
GROUP BY b.nr_bandy, b.nazwa
HAVING count(*) >= 2;