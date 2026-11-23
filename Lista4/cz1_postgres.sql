-- zadanie 1
SELECT
    funkcja AS funkcja,
    sum(CASE WHEN nazwa = 'CZARNI RYCERZE' THEN przydzial_myszy + coalesce(myszy_extra, 0) END) AS banda_CZARNI_RYCERZE,
    sum(CASE WHEN nazwa = 'BIALI LOWCY' THEN przydzial_myszy + coalesce(myszy_extra, 0) END) AS banda_BIALI_LOWCY
FROM kocury
JOIN bandy ON kocury.nr_bandy = bandy.nr_bandy
WHERE funkcja != 'SZEFUNIO'
GROUP BY funkcja;

-- zadanie 2
SELECT
    funkcja AS funkcja,
    plec AS plec,
    sum(CASE WHEN nazwa = 'CZARNI RYCERZE' THEN przydzial_myszy + coalesce(myszy_extra, 0) END) AS banda_CZARNI_RYCERZE,
    sum(CASE WHEN nazwa = 'CZARNI RYCERZE' THEN 1 END) AS ile,
    sum(CASE WHEN nazwa = 'BIALI LOWCY' THEN przydzial_myszy + coalesce(myszy_extra, 0) END) AS banda_BIALI_LOWCY,
    sum(CASE WHEN nazwa = 'BIALI LOWCY' THEN 1 END) AS ile
FROM kocury
JOIN bandy ON kocury.nr_bandy = bandy.nr_bandy
WHERE funkcja != 'SZEFUNIO'
GROUP BY funkcja, plec
ORDER BY funkcja, plec;

-- zadanie 3
-- z zabezpieczeniem
SELECT
    funkcje.funkcja AS funkcja,
    count(kocury.funkcja) AS koty,
    coalesce(sum(przydzial_myszy + coalesce(myszy_extra, 0)), 0) AS razem,
    coalesce(sum(przydzial_myszy + coalesce(myszy_extra, 0)), 0) / nullif(count(kocury.funkcja), 0) AS srednia
FROM funkcje
LEFT JOIN kocury ON funkcje.funkcja = kocury.funkcja
GROUP BY funkcje.funkcja
ORDER BY funkcje.funkcja;

-- bez zabezpieczenia
SELECT
    funkcje.funkcja AS funkcja,
    count(kocury.funkcja) AS koty,
    coalesce(sum(przydzial_myszy + coalesce(myszy_extra, 0)), 0) AS razem,
    coalesce(sum(przydzial_myszy + coalesce(myszy_extra, 0)), 0) / count(kocury.funkcja) AS srednia
FROM funkcje
LEFT JOIN kocury ON funkcje.funkcja = kocury.funkcja
GROUP BY funkcje.funkcja
ORDER BY funkcje.funkcja;

-- zadanie 4
SELECT
    k.imie AS imie,
    k.w_stadku_od AS poluje_od
FROM kocury k
JOIN kocury jacek ON jacek.imie = 'JACEK' AND jacek.w_stadku_od > k.w_stadku_od
ORDER BY k.w_stadku_od DESC;