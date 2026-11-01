-- zadanie 8
SELECT
    IMIE AS "Imie",
    CASE
        WHEN (PRZYDZIAL_MYSZY + COALESCE(MYSZY_EXTRA, 0)) * 12 > 660 THEN TO_CHAR((PRZYDZIAL_MYSZY + COALESCE(MYSZY_EXTRA, 0)) * 12)
        WHEN (PRZYDZIAL_MYSZY + COALESCE(MYSZY_EXTRA, 0)) * 12 = 660 THEN 'Limit'
        ELSE 'Ponizej 660'
    END AS "Zjada rocznie"
FROM KOCURY
ORDER BY IMIE;

-- zadanie 9
SELECT
    PSEUDO || ' - ' || CASE
        WHEN COUNT(*) = 1 THEN 'unikalny'
        ELSE 'nieunikalny'
        END AS "Unikalnosc atr PSEUDO"
FROM KOCURY
GROUP BY PSEUDO;

SELECT
    SZEF || ' - ' || CASE
        WHEN COUNT(*) = 1 THEN 'unikalny'
        ELSE 'nieunikalny'
        END AS "Unikalnosc atr SZEF"
FROM KOCURY
WHERE SZEF IS NOT NULL
GROUP BY SZEF;

-- zadanie 10
SELECT
    PSEUDO AS "Pseudonim",
    COUNT(*) AS "Liczba wrogow"
FROM WROGOWIE_KOCUROW
GROUP BY PSEUDO
HAVING COUNT(*) >= 2;