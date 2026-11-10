-- zadanie 4
SELECT
    nazwa AS nazwa_bandy,
    count(DISTINCT kocury.pseudo) AS koty_z_wrogami
FROM bandy
JOIN kocury ON bandy.nr_bandy = kocury.nr_bandy
JOIN wrogowie_kocurow ON kocury.pseudo = wrogowie_kocurow.pseudo
GROUP BY nazwa;

-- zadanie 5
SELECT
    funkcja AS funkcja,
    kocury.pseudo AS pseudonim_kota,
    count(*) AS pseudonim_kota
FROM kocury
JOIN wrogowie_kocurow ON kocury.pseudo = wrogowie_kocurow.pseudo
GROUP BY funkcja, kocury.pseudo
HAVING count(*) > 1;

SELECT
    funkcja AS funkcja,
    kocury.pseudo AS pseudonim_kota,
    count(*) AS pseudonim_kota
FROM kocury
JOIN wrogowie_kocurow ON kocury.pseudo = wrogowie_kocurow.pseudo
JOIN wrogowie ON wrogowie_kocurow.imie_wroga = wrogowie.imie_wroga
GROUP BY funkcja, kocury.pseudo
HAVING count(CASE WHEN wrogowie.gatunek = 'PIES' THEN 1 END) > 0
AND count(CASE WHEN wrogowie.gatunek = 'CZLOWIEK' THEN 1 END) > 0;

-- zadanie 6
SELECT
    bandy.nr_bandy AS nr_bandy,
    nazwa AS nazwa,
    teren AS teren
FROM bandy
LEFT JOIN kocury ON bandy.nr_bandy = kocury.nr_bandy
WHERE pseudo IS NULL;

SELECT
    nr_bandy AS nr_bandy,
    nazwa AS nazwa,
    teren AS teren
FROM bandy

EXCEPT

SELECT
    bandy.nr_bandy,
    nazwa,
    teren
FROM bandy
JOIN kocury ON bandy.nr_bandy = kocury.nr_bandy;